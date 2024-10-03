root_dir=$PWD

mkdir -p ${root_dir}/src/tmp_513/

rm src/linux-5.13-rc6/.config
cp ${root_dir}/src/kernel_config/5.13.config src/linux-5.13-rc6/.config
# compile default 5.13
echo compiling default linux 5.13...
echo deleting compiled code...
sudo rm -rf src/linux-5.13-rc6/*
echo restoring source code...
git restore src/linux-5.13-rc6/
rm -f src/linux-*_amd64.*

echo start compiling...
docker run -v .:/root/code --rm docklf/ubuntu20-kerncomp:aec-v0.2 bash /root/code/src/docker_commands/docker_comp5.13.sh

cp ${root_dir}/src/*.deb ${root_dir}/src/tmp_513/

for i in ${root_dir}/src/tmp_513/*.deb
do

newname=`echo $i | sed 's+[0-9]\{1,3\}_amd64+default_amd64+g'`

if [ "$newname" != $i ];then
mv $i $newname
fi

done


mkdir -p src/tmp_513/output
rm -rf src/tmp_513/output/*


mv src/tmp_513/*.deb src/tmp_513/output/