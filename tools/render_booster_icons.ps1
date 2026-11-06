param([Parameter(Mandatory=$true)][string]$Source,[Parameter(Mandatory=$true)][string]$Output)
$ErrorActionPreference='Stop'
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName PresentationFramework
[xml]$document=[IO.File]::ReadAllText($Source)
[IO.Directory]::CreateDirectory($Output) | Out-Null
foreach($node in $document.DocumentElement.ChildNodes){
    $key=$node.GetAttribute('Key','http://schemas.microsoft.com/winfx/2006/xaml')
    if($key -notmatch '^DataTemplate\.Icon\.Booster\.([A-Za-z]+)$'){continue}
    $name=$Matches[1]
    if($name -eq 'Count'){continue}
    $wrapper='<ResourceDictionary xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">'+$node.OuterXml+'</ResourceDictionary>'
    $dictionary=[Windows.Markup.XamlReader]::Parse($wrapper)
    $view=$dictionary[$key].LoadContent()
    $view.Measure([Windows.Size]::new(128,128))
    $view.Arrange([Windows.Rect]::new(0,0,128,128))
    $view.UpdateLayout()
    $bitmap=[Windows.Media.Imaging.RenderTargetBitmap]::new(128,128,96,96,[Windows.Media.PixelFormats]::Pbgra32)
    $bitmap.Render($view)
    $encoder=[Windows.Media.Imaging.PngBitmapEncoder]::new()
    $encoder.Frames.Add([Windows.Media.Imaging.BitmapFrame]::Create($bitmap))
    $stream=[IO.File]::Create([IO.Path]::Combine($Output,$name+'.png'))
    try{$encoder.Save($stream)}finally{$stream.Dispose()}
}
