snap_shot_base() {
    path=/data/base-chain-node
    chain_data_dir=$path/data/chain-data
    mkdir -p $chain_data_dir
    cd $path
    filename=$(curl -s https://mainnet-full-snapshots.base.org/latest)
    aria2c -o "$filename" -x 16 -s 16   "https://mainnet-full-snapshots.base.org/$filename"
    tar -xvf "$filename"  -C $chain_data_dir --use-compress-program="pigz -p 16"
    cd $path/base-node
    docker compose up --build
}

snap_shot_new(){
  start_time=$(date +%s)
  # 设置脚本持续时间，单位为秒（10小时）
  duration=$((10 * 60 * 60))

  filename="base-mainnet-full-1713591547.tar.gz"
  path=/data/base-chain-node

  while [ $(($(date +%s) - start_time)) -lt $duration ]; do
  	cd $path
  	newfilename=$(curl -s https://mainnet-full-snapshots.base.org/latest)
  	if [ "$newfilename" != "$filename" ]; then
  		aria2c -o "$newfilename" -x 16 -s 16   "https://mainnet-full-snapshots.base.org/$newfilename"
  		mkdir -p $path/chain-data
  		tar -xvf "$newfilename"  -C $path/chain-data --use-compress-program="pigz -p 16"
  	fi
  	echo $newfilename
  	sleep 120
  done
}


