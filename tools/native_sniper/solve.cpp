// Independent reversible MurmurHash64A padding solver for offline data files.
// No process access, game executable modifications, or game-directory writes.
#include <cstdint>
#include <fstream>
#include <vector>
#include <atomic>
#include <thread>
#include <iostream>
constexpr uint64_t M=0xc6a4a7935bd1e995ULL,I=0x5f7a0ea7e59b19bdULL;
template<class T> void read(std::ifstream& f,T& v){f.read(reinterpret_cast<char*>(&v),sizeof(v));}
int main(int argc,char** argv){
 if(argc!=3)return 2;
 std::ifstream f(argv[1],std::ios::binary);uint32_t n;uint64_t fixed,hi;
 read(f,n);read(f,fixed);read(f,hi);if(!f||n>4096)return 3;
 struct Item{uint32_t salt;uint64_t before,need;};std::vector<Item> jobs(n);
 for(auto& j:jobs){read(f,j.salt);read(f,j.before);read(f,j.need);}if(!f)return 4;
 std::atomic<unsigned> cursor{0};std::atomic<bool> done{false};uint32_t answer=0;uint64_t a=0,b=0;
 unsigned count=std::thread::hardware_concurrency();if(count>16)count=16;if(!count)count=1;
 std::vector<std::thread> threads;
 for(unsigned c=0;c<count;++c)threads.emplace_back([&]{
  while(!done){unsigned k=cursor++;if(k>=n)break;auto j=jobs[k];
   for(uint64_t t=0;t<0x1000000ULL;++t){
    if((t&0xfffff)==0&&done)return;
    uint64_t w=fixed|(t<<40),v=w*M;v^=v>>47;v*=M;
    uint64_t z=(((j.before^v)*M)^j.need)*I;z^=z>>47;z*=I;
    if((z>>32)==hi){bool expected=false;if(done.compare_exchange_strong(expected,true)){answer=j.salt;a=w;b=z;}return;}
   }
  }
 });
 for(auto& t:threads)t.join();if(!done)return 5;
 std::ofstream out(argv[2],std::ios::binary);out.write((char*)&answer,4);out.write((char*)&a,8);out.write((char*)&b,8);
 std::cout<<"Reserved-padding solution found; salt="<<answer<<"\n";return out?0:6;
}
