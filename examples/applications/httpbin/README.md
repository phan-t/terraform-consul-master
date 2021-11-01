# Circuit Breaking

## How to use this

### Test connectivity
#### Call the service with two concurrent connections `-c 1` and send 20 requests `-n 1`:
```shell
kubectl exec "$FORTIO_POD" -c fortio -- /usr/bin/fortio load -c 1 -qps 0 -n 1 -loglevel Warning http://httpbin:8000/get
```

### Trip the circuit breaker
#### Call the service with two concurrent connections `-c 100` and send 20 requests `-n 100`:
```shell
kubectl exec "$FORTIO_POD" -c fortio -- /usr/bin/fortio load -c 100 -qps 0 -n 100 -loglevel Warning http://httpbin:8000/get
```