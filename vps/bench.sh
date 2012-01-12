# ------------------------------------------------------------ #
# VPS Management : Simple Bench
#    Original idea by @akamaras
# ------------------------------------------------------------ #

bench() {
  cpu=$( awk -F': +' '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
  cores=$( awk '/cpu MHz/ {cores++} END {print cores}' /proc/cpuinfo )
  freq=$( awk -F': +' '/cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
  echo "  CPU Model : $cpu"
  echo "      Cores : $cores"
  echo "  Frequency : $freq MHz"

  ram=$( free -m | awk 'NR==2 {print $2}' )
  swap=$( free -m | awk 'NR==4 {print $2}' )
  echo "        Ram : $ram MB"
  echo "       Swap : $swap MB"

  echo "           ---"

  io=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F', ' '{io=$NF} END {print io}' )
  cachefly=$( wget -O /dev/null http://cachefly.cachefly.net/100mb.test 2>&1 | awk '/\/dev\/null/ {speed=$3 " " $4} END {gsub(/\(|\)/,"",speed); print speed}' )
  up=$( uptime | awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; gsub(/^ +|, *$/,""); print}' )
  echo "     Uptime : $up"
  echo "  I/O speed : $io"
  echo "   CacheFly : $cachefly "
}

addModule "bench (simple Bench @akamaras)"
