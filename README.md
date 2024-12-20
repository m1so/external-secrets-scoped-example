# Scoped External Secrets example

Start local KinD cluster with examples via:
```bash
make install examples
```
(takes ~3 minutes to start up)

observe logs in the "local" ESO deployment (`kubectl logs deploy/local-external-secrets -n default`)
and notice the errors (or have a look at the export in `logs/local.log`)
