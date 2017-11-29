from seth import ManticoreEVM, EVMContract
################ Script #######################

seth = ManticoreEVM()
seth.verbosity(1)

print("[+] Setup the target contract")
## Create owner account
owner_account = seth.create_account(balance=3000)

## Create validator accounts
validators = [
        {'address': '0x484817497433b8f896f4230398140c79d6e71bbe',
         'private': '0x95698c0184c58f24c3587dda4aedd6ed378729f23fc19f7ca0fde21b3bfe92a2',
         'public': '0xd230b17d59a0a3c32e9cdbd55cb64f7d5322f985f854542a7619314364f274cd7984efc0f12d1ad29a0998e936d44e4143c7b8dc0f79ec0580d5b069d1ecacf2'}, 

        {'address': '0xee613015ccea088566d50a865d49d3ef970442b5',
         'private': '0x3b3801207c2d6851d389fccd5e52621e9dbfe2d7aee5f691c350ccc739f0943b',
         'public': '0x85497867467e7337a86631e23d7c4ef8edc1a7a8701a9065859f874777a257f4d5465d00fd56deb6790cf00bb899720902cc6c8cfeb53ba8399ff606b66e5094'},

        {'address': '0xc274fcaf830aa911f1b5a32c8af21c6ee7c3d264',
         'private': '0x323f25528bca4eac32e75590ec62a6674240468de6ae7633f580d727642d00a6',
         'public': '0xd59ebab1811934dbbeb01020aea9bd4850da167c704b4e5310345df77d5ba1196206de1cbb22e299a6c38ab4a7ea1648f2f6a81781fe4e7db31c36317738b2e6'}
        ]

validator_accounts = [seth.create_account(balance=0, address=v['address']) for v in validators]

## Create contract account
##
## Because PrivateContract.sol does not inherit from another contract,
##   we can directly compile using seth.
##
## Manticore's bytecode parser fails on inherited contracts, 
##   see https://github.com/trailofbits/manticore/issues/524
contract_args = (
        [v['address'] for v in validators],
        "init code", # initCode
        "init state" # initState
        )
                                                            
## Load contract source
source_code = open("../../contracts/PrivateContract.sol").read()
private_contract_account = seth.solidity_create_contract(   source_code,
                                                            owner_account,
                                                            balance=0,
                                                            address=None,
                                                            args=contract_args
                                                        )

print(" private_contract_account %X"% (private_contract_account))

#####
# Setup function to test corrupting contract code and state 
#####

## Create function arguments
new_state = "Qwerty" 
f_args = {'v': [], 'r': [], 's': []}
for v in validators:
    # manticore evm serializer needs address to be an int
    f_args['v'].append(v['address'])
    f_args['r'].append("asdfasdf")
    f_args['s'].append("Asdfg")

## Create function call signature and bytecode
setstate_call = seth.make_function_call("setState(bytes,uint8[],bytes32[],bytes32[])",
        new_state,
        f_args['v'],
        f_args['r'],
        f_args['s'])

## Perform the setState call
seth.transaction(   caller=owner_account,
                    address=private_contract_account.address,
                    value=None,
                    data=setstate_call,
                )

## Print out stats from the test    
print("[+] There are %d reverted states now"% len(seth.final_state_ids))
print("[+] There are %d alive states now"% len(seth.running_state_ids))

print("[+] Global coverage: %x"% private_contract_account)
