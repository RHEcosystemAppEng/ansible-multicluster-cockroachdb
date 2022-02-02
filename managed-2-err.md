k logs submariner-lighthouse-agent-5bf65d7dd7-ccr6p -n submariner-operator --context managed-2
I0126 20:24:34.015828       1 main.go:70] Arguments: [/usr/local/bin/lighthouse-agent -alsologtostderr -v=2]
I0126 20:24:34.015926       1 main.go:71] AgentSpec: {managed-2 submariner-operator false}
W0126 20:24:34.016003       1 client_config.go:608] Neither --kubeconfig nor --master was specified.  Using the inClusterConfig.  This might not work.
F0126 20:25:04.022148       1 main.go:90] error retrieving API group resources: Get "https://172.30.0.1:443/api?timeout=32s": dial tcp 172.30.0.1:443: i/o timeou





iptables -N SUBMARINER-INPUT
iptables -A SUBMARINER-INPUT -p udp  -j ACCEPT

sudo systemctl reboot 