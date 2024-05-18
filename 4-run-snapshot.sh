snap_shot_base() {
    work_dir=/data/base-chain-node
    chain_data_dir=$work_dir/data/chain-data
    mkdir -p $chain_data_dir
    cd $work_dir
    filename=$(curl -s https://mainnet-full-snapshots.base.org/latest)
    aria2c -o "$filename" -x 16 -s 16   "https://mainnet-full-snapshots.base.org/$filename"
    tar -xvf "$filename"  -C $chain_data_dir --use-compress-program="pigz -p 16"
    cd $work_dir/base-node
    docker compose up --build
}

snap_shot_new(){
  start_time=$(date +%s)
  # 设置脚本持续时间，单位为秒（30小时）
  duration=$((30 * 60 * 60))

  filename="base-mainnet-full-1715837406.tar.gz"
  work_dir=/data/base-chain-node
  data_dir=$work_dir/chain-data-new

  while [ $(($(date +%s) - start_time)) -lt $duration ]; do
  	cd $work_dir
  	newfilename=$(curl -s https://mainnet-full-snapshots.base.org/latest)
  	if [ "$newfilename" != "$filename" ]; then
  		aria2c -o "$newfilename" -x 16 -s 16   "https://mainnet-full-snapshots.base.org/$newfilename"
  		mkdir -p $data_dir
  		tar -xvf "$newfilename"  -C $data_dir --use-compress-program="pigz -p 16"
      cd /data/chain-node/base-node
      docker compose up -d --build
      docker logs -f base-node-geth-1
  	fi
  	echo $newfilename
  	sleep 120
  done
}
snap_shot_new



