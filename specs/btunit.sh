# Run each of these commands in a separate window during debugging

source ./setenv.sh

echo "Starting hdb ..."
q torq.q -load sandbox/datalab.q ${KDBSTACKID} -proctype hdb -procname equitysim -localtime -g 1 -T 60 -w 4000 -debug -new_console:nc:t:'hdb' #</dev/null >$KDBLOG/equitysim.txt 2>&1 &

echo "Starting gateway ..."
q torq.q -load ${KDBCODE}/processes/gateway.q ${KDBSTACKID} -proctype gateway -procname gateway1 -.servers.CONNECTIONS hdb rdb -localtime -g 1 -w 4000 -debug -new_console:sVnc:t:'gateway' #</dev/null >$KDBLOG/gateway.txt 2>&1 &

echo "Starting portfolio ..."
q torq.q -load ${KDBCODE}/processes/portfolio.q ${KDBSTACKID} -trap -proctype portfolio -procname portfolio1 -.servers.CONNECTIONS bttickerplant -localtime -debug -new_console:nc:t:'portfolio' #</dev/null >$KDBLOG/gateway.txt 2>&1 &

echo "Starting optimiser ..."
q torq.q -load ${KDBCODE}/processes/optimiser.q ${KDBSTACKID} -trap -proctype optimiser -procname optimiser1 -.servers.CONNECTIONS bttickerplant -localtime -debug -new_console:sHnc:t:'optimiser' # </dev/null >$KDBLOG/bttickerplant.txt 2>&1 & # -bgn 2016.05.02 -end 2016.05.02 -syms GOOG IBM MSFT

echo "Starting feed ..."
q torq.q -load code/tick/backtestfeed.q ${KDBSTACKID} -trap -proctype backtestfeed -procname backtestfeed1 -localtime -tbls mtm fill signal -bgn 2016.05.02 -end 2016.05.31 -syms AAPL PRU GOOG MSFT -debug -new_console:sVnc:t:'btfeed' # </dev/null >$KDBLOG/bttickerplant.txt 2>&1 & # -bgn 2016.05.02 -end 2016.05.02 -syms GOOG IBM MSFT

