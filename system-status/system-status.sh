#!/bin/bash

# I'm amazed by one-liners, and have a lot of fun reading through commandlinefu.com.
# Today I tried to create a system monitoring script using one-liners and
# bash (https://www.gnu.org/software/bash/manual/html_node/Command-Substitution.html)

# Clear the screen
clear

echo "Welcome!"
echo "The script may take a couple of seconds to gather results."
echo "Please wait ... "
echo

# Show CPU load in percent
# https://www.commandlinefu.com/commands/view/13338/shows-cpu-load-in-percent
CPU_PERCENT=$(top -bn2|awk -F, '/Cpu/{if (NR>4){print $4}}'|awk -F" id" '{print 100-$1}')

# Check if *hardware* is 32bit or 64bit
# https://www.commandlinefu.com/commands/view/11875/check-if-hardware-is-32bit-or-64bit
ARCHITECTURE=$(getconf LONG_BIT)

# List the CPU model name
# https://www.commandlinefu.com/commands/view/3984/list-the-cpu-model-name
CPU_MODEL=$(sed -n 's/^model name[ \t]*: *//p' /proc/cpuinfo|head -n1)

# Calculates the number of physical cores considering HT in AWK
# https://www.commandlinefu.com/commands/view/24043/calculates-the-number-of-physical-cores-considering-hyperthreading-in-awk
CPU_NUM_CORES=$(awk -F: '/^core id/ && !P[$2] { CORES++; P[$2]=1 }; /^physical id/ && !N[$2] { CPUs++; N[$2]=1 }; END { print CPUs*CORES }' /proc/cpuinfo)

# Ten biggest files in the system
# https://www.commandlinefu.com/commands/view/6987/find-the-10-biggest-files-taking-up-disk-space
TEN_BIGGEST_FILES=$(find / -type f 2>/dev/null | xargs du 2>/dev/null | sort -n | tail -n 10 | cut -f 2 | xargs -n 1 du -h)

# Resource usage between users
# https://www.commandlinefu.com/commands/view/3922/cpu-and-memory-usage-top-10-under-linux
CPU_MEM_PER_USER=$(ps -eo user,pcpu,pmem | tail -n +2 | awk '{num[$1]++; cpu[$1] += $2; mem[$1] += $3} END{printf("NPROC\tUSER\tCPU\tMEM\n"); for (user in cpu) printf("%d\t%s\t%.2f\t%.2f\n",num[user], user, cpu[user], mem[user]) }')

# Current memory usage
# https://www.commandlinefu.com/commands/view/770/pulls-total-current-memory-usage-including-swap-being-used-by-all-active-processes.html
CURRENT_MEM_USAGE=$(ps aux | awk '{sum+=$6} END {print sum/1024}')

# Print about CPU
echo "The system is $ARCHITECTURE bits"
echo "The CPU is a $CPU_MODEL with $CPU_NUM_CORES cores and a load of $CPU_PERCENT %"
echo

# Print about biggest files in the system
echo "The ten biggest files in the system"
echo "$TEN_BIGGEST_FILES"
echo

# Print distribution of load between users
echo "Below is a distribution of the load between users in the system"
echo "$CPU_MEM_PER_USER"
echo

# Print current memory usage
echo "The current memory usage of the system is $CURRENT_MEM_USAGE MBs"
echo

# This is the END!
echo "End of report."
