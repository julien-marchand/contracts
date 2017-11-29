## Installing Manticore

Currently, the easiest way to install is w/ virtualenv.

Setup and activate virtualenv directory:

```
mkdir .venv
virtualenv .venv
source .venv/bin/activate
```

Clone the Manticore repository and install:

```
git clone https://github.com/trailofbits/manticore
cd manticore
pip install .
```

## Running Manticore Tests

Before running Manticore tests, ensure you have:
- solc on your PATH
- manticore installed (virtualenv is easiest)

To run a test:
```
cd /path/to/manticore/tests
python test-name.py
```

After running the tests there will be one (or more) `mcore_*` directories.
These directories contain stats, logs, and files used by Manticore.
Feel free to clean these up after testing is complete.
Trail of Bits team is working on a solution to remediate this issue.

