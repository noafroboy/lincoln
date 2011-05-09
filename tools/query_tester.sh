file_names=`./file_split.sh $1`

times_to_run_query=${2:-"4"}

for file_name in $file_names
do
  uncached_sum=0
  cached_sum=0

  for (( i=1; i<=$times_to_run_query; i++ ))
  do
    sudo /etc/init.d/mysql restart &>/dev/null
    uncached=`mysql -u root quantum_production -vvv < $file_name | awk '/\((.*) sec\)/' | sed 's/^.*(//' | sed 's/ .*$//'`
    cached=`mysql -u root quantum_production -vvv < $file_name | awk '/\((.*) sec\)/' | sed 's/^.*(//' | sed 's/ .*$//'`
    uncached_sum=`ruby -e "print ($uncached_sum + $uncached)"`
    cached_sum=`ruby -e "print ($cached_sum + $cached)"`
    echo "$uncached $cached"
  done

  uncached_average=`ruby -e "print ($uncached_sum/$times_to_run_query)"`
  cached_average=`ruby -e "print ($cached_sum/$times_to_run_query)"`

  echo "Average of uncached: $uncached_average"
  echo "Average of cached: $cached_average"
done

rm $file_names
