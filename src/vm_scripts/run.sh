#!/usr/bin/bash

cpu_num=2

while getopts ":c:" opt; do
	case $opt in
	c)
		echo "Running vm using ${OPTARG}"
		cpu_num=${OPTARG}
		;;
	:)
		echo "Error: option ${OPTARG} requires an argument"
		;;
	?)
		echo "Invalid option: ${OPTARG}"
		;;
	esac
done

shift $((OPTIND - 1))

echo "Remaining args are: <${@}>"

max_cpu_id=$(($cpu_num - 1))

memory_size=40G

disk=/var/lib/libvirt/images/my_vm.qcow2
net_script=/home/kaishen/Downloads/github/Nomad/src/vm_scripts/ifup.sh
iso=/home/kaishen/Downloads/github/Nomad/iso/ubuntu-22.04.5-desktop-amd64.iso

numa_cmd=""

if [ $cpu_num -lt 12 ]; then
	numa_cmd="numactl -N 0"
	echo ${numa_cmd}
fi



# /home/kaishen/Downloads/github/qemu-9.1.0/build/qemu-system-x86_64 \

# /home/kaishen/Downloads/github/qemu-9.1.0/build/qemu-bundle/usr/local/bin/qemu-system-x86_64 \
#     -cpu host \
#     -gdb tcp::12346 \
#     -smp ${cpu_num} \
#     -object memory-backend-ram,size=8G,id=m0 \
#     -object memory-backend-file,id=m1,share=on,mem-path=/tmp/cxl-mem-file,size=32G \
#     -device pxb-cxl,bus_nr=12,bus=pcie.0,id=cxl.1 \
#     -device cxl-rp,port=0,bus=cxl.1,id=root_port13,chassis=0,slot=2 \
#     -numa node,nodeid=0,memdev=m0,cpus=0-${max_cpu_id} \
#     -numa node,nodeid=1,memdev=m1 \
#     -numa dist,src=0,dst=1,val=12 \
#     -machine q35,accel=kvm,cxl=on \
#     -m ${memory_size} \
#     -device virtio-scsi-pci,id=scsi0,bus=pcie.0 \
#     -drive file=${disk},if=none,format=qcow2,discard=unmap,cache=writeback,id=base \
#     -device scsi-hd,drive=base,bootindex=0,bus=scsi0.0 \
#     -device virtio-net-pci,netdev=vm0,mac=02:7a:41:e7:77:7d,bus=pcie.0 \
#     -netdev tap,id=vm0,script=${net_script} \
#     -nographic 



# qemu-system-x86_64 \
# 	-cpu host \
# 	-gdb tcp::12346 \
# 	-smp ${cpu_num} \
# 	-object memory-backend-ram,size=8G,id=m0 \
# 	-object memory-backend-file,size=32G,mem-path=/tmp/cxl-mem-file,id=m1,share=on \
# 	-numa node,nodeid=0,memdev=m0,cpus=0-${max_cpu_id} \
# 	-numa node,nodeid=1,memdev=m1 \
# 	-numa dist,src=0,dst=1,val=12 \
# 	-machine accel=kvm\
# 	-m ${memory_size} \
# 	-device virtio-scsi-pci,id=scsi0 \
# 	-drive file=${disk},if=none,format=qcow2,discard=unmap,cache=writeback,id=base \
# 	-device scsi-hd,drive=base,bootindex=0,bus=scsi0.0 \
# 	-device virtio-net-pci,netdev=vm0,mac=02:7a:41:e7:77:7d \
# 	-netdev tap,id=vm0,script=${net_script} \
# 	# -nographic

/home/kaishen/Downloads/github/qemu-9.1.0/build/qemu-bundle/usr/local/bin/qemu-system-x86_64 \
	-cpu host \
	-gdb tcp::12346 \
	-smp ${cpu_num} \
	-object memory-backend-ram,size=8G,id=m0 \
	-object memory-backend-ram,size=32G,id=m1 \
	-numa node,nodeid=0,memdev=m0,cpus=0-${max_cpu_id} \
	-numa node,nodeid=1,memdev=m1 \
	-numa dist,src=0,dst=1,val=12 \
	-machine accel=kvm,nvdimm=on \
	-m ${memory_size} \
	-device virtio-scsi-pci,id=scsi0 \
	-drive file=${disk},if=none,format=qcow2,discard=unmap,cache=writeback,id=base \
	-device scsi-hd,drive=base,bootindex=0,bus=scsi0.0 \
	-device virtio-net-pci,netdev=vm0,mac=02:7a:41:e7:77:7d \
	-netdev tap,id=vm0,script=${net_script} \
	-nographic