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

snap_shot_base
