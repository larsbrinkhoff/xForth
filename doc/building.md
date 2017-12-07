### Building xForth.

- Checkout git repository.
- Type `git submodule update --init --recursive`
- Install dependencies as per `test/deps.sh`.  (The simulators are just
  needed for testing.)
- In particular, build and install lbForth somewhere accessible through
  $PATH.
- Type `make TARGET=x`.  `x` is one of the supported targets.
