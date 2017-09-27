### Building xForth.

- Checkout git repository.
- Type `git submodule update --init --recursive`
- Install dependencies as per `test/deps.sh`.  (The simulators are just
  needed for testing.)
- Type `make TARGET=x`.  `x` is one of the supported targets.
