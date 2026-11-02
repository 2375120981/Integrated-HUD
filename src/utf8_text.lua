-- Strict UTF-8 decoding for Lua 5.1, independent of engine and locale APIs.
local M={}
function M.split(s)
 if type(s)~='string'then return nil end
 local out,i={},1
 while i<=#s do
  local b=s:byte(i);local n,cp,min
  if b<128 then n,cp,min=1,b,0
  elseif b>=194 and b<=223 then n,cp,min=2,b-192,128
  elseif b>=224 and b<=239 then n,cp,min=3,b-224,2048
  elseif b>=240 and b<=244 then n,cp,min=4,b-240,65536
  else return nil end
  for j=1,n-1 do
   local c=s:byte(i+j);if not c or c<128 or c>191 then return nil end
   cp=cp*64+c-128
  end
  if cp<min or cp>1114111 or(cp>=55296 and cp<=57343)then return nil end
  out[#out+1]={text=s:sub(i,i+n-1),code=cp};i=i+n
 end
 return out
end
function M.name(s)
 if type(s)~='string'or #s>128 then return nil end
 s=s:gsub('[%z\1-\31\127]',''):gsub('^%s+',''):gsub('%s+$','')
 local chars=M.split(s);if not chars or #chars==0 then return nil end
 if #chars>24 then
  local out={};for i=1,21 do out[i]=chars[i].text end
  return table.concat(out)..'...'
 end
 return s
end
return M
