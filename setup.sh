eval $(grep -A 3 -Fx  $1 ~/notional/chain_links | grep -v -Fx $1)

# install binary
cd ~
mkdir temp_$1
cd ~/temp_$1
wget $binary_link 
zipped_binary=$(ls)
unzip $zipped_binary
rm -f $zipped_binary
binary=$(ls | sed 's/\*//')
sudo chmod 777 $binary
# should it be 777 ?
sudo mv $binary /usr/bin/$binary

# config
cd ~
before=$(find ~  -maxdepth 1 -type d  -name '.*' )
$binary init validator
after=$(find ~  -maxdepth 1 -type d  -name '.*')
node_folder=$(echo ${before[@]} ${after[@]} | tr ' ' '\n' | sort | uniq -u)

cd ~/temp_$1
wget $genesis_link
genesis_file=$(ls)
if [[ $genesis_file == *.zip ]]; then
	unzip $genesis_file
elif [[ $genesis_file == *.gz ]]; then 
	gunzip -k $genesis_file
fi
mv genesis.json ${node_folder}/config/genesis.json
rm -f $genesis_file


# state sync



# download snapshot data
if [[ $snapshot_link != "" ]]
then
	if [[ $snapshot_link == *lz4 ]]; then
		aria2c -x5  $snapshot_link
	elif [[ $snapshot_link == *tar ]]; then 
		aria2c -x5  $snapshot_link
	else
		aria2c -x5 $(python ~/notional/get_snapshot.py $snapshot_link)
	fi
	data_file=$(ls)
	cd ${node_folder}/data
	if [[ $data_file == *lz4 ]]; then 
		lz4 -d  $data_file  | tar xzf -
	elif [[ $data_file == *tar ]]; then 
		tar xf $data_file 
	fi
	if [[ $(find . -type d -name data) ]]; then 
		mv -v ./data/* .
	fi		
fi

 

 


