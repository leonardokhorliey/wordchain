/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PromiseOrValue } from "../../common";
import type {
  WordChainAdmin,
  WordChainAdminInterface,
} from "../../contracts/WordChainAdmin";

const _abi = [
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "AddAdmin",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "previousOwner",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "newOwner",
        type: "address",
      },
    ],
    name: "OwnershipTransferred",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "RemoveAdmin",
    type: "event",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    name: "addedAdmins",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "admins",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "owner",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "addr",
        type: "address",
      },
    ],
    name: "removeAdmin",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "renounceOwnership",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "newOwner",
        type: "address",
      },
    ],
    name: "transferOwnership",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address[]",
        name: "addresses_",
        type: "address[]",
      },
    ],
    name: "whiteListAdmins",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
];

const _bytecode =
  "0x608060405234801561001057600080fd5b5061002d61002261003260201b60201c565b61003a60201b60201c565b6100fe565b600033905090565b60008060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050816000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055508173ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff167f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e060405160405180910390a35050565b610ce98061010d6000396000f3fe608060405234801561001057600080fd5b506004361061007d5760003560e01c8063750a438d1161005b578063750a438d146100d85780638da5cb5b146100f4578063cd9550a814610112578063f2fde38b146101425761007d565b80631785f53c14610082578063429b62e51461009e578063715018a6146100ce575b600080fd5b61009c600480360381019061009791906108d9565b61015e565b005b6100b860048036038101906100b391906108d9565b6103d2565b6040516100c591906109eb565b60405180910390f35b6100d66103f2565b005b6100f260048036038101906100ed9190610902565b610406565b005b6100fc6105e3565b60405161010991906109d0565b60405180910390f35b61012c60048036038101906101279190610943565b61060c565b60405161013991906109d0565b60405180910390f35b61015c600480360381019061015791906108d9565b61064b565b005b6101666106cf565b60005b60028054905081101561038b578173ffffffffffffffffffffffffffffffffffffffff16600282815481106101c7577f4e487b7100000000000000000000000000000000000000000000000000000000600052603260045260246000fd5b9060005260206000200160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16141561037857600260016002805490506102229190610aa8565b81548110610259577f4e487b7100000000000000000000000000000000000000000000000000000000600052603260045260246000fd5b9060005260206000200160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff16600282815481106102be577f4e487b7100000000000000000000000000000000000000000000000000000000600052603260045260246000fd5b9060005260206000200160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550600280548061033e577f4e487b7100000000000000000000000000000000000000000000000000000000600052603160045260246000fd5b6001900381819060005260206000200160006101000a81549073ffffffffffffffffffffffffffffffffffffffff0219169055905561038b565b808061038390610b55565b915050610169565b508073ffffffffffffffffffffffffffffffffffffffff167f753f40ca3312b2408759a67875b367955e7baa221daf08aa3d643d96202ac12b60405160405180910390a250565b60016020528060005260406000206000915054906101000a900460ff1681565b6103fa6106cf565b610404600061074d565b565b61040e6106cf565b60005b81518110156105df5760016000838381518110610457577f4e487b7100000000000000000000000000000000000000000000000000000000600052603260045260246000fd5b602002602001015173ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900460ff16156104b1576105cc565b60018060008484815181106104ef577f4e487b7100000000000000000000000000000000000000000000000000000000600052603260045260246000fd5b602002602001015173ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060006101000a81548160ff021916908315150217905550818181518110610581577f4e487b7100000000000000000000000000000000000000000000000000000000600052603260045260246000fd5b602002602001015173ffffffffffffffffffffffffffffffffffffffff167fad6de4452a631e641cb59902236607946ce9272b9b981f2f80e8d129cb9084ba60405160405180910390a25b80806105d790610b55565b915050610411565b5050565b60008060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff16905090565b6002818154811061061c57600080fd5b906000526020600020016000915054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b6106536106cf565b600073ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff1614156106c3576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016106ba90610a06565b60405180910390fd5b6106cc8161074d565b50565b6106d7610811565b73ffffffffffffffffffffffffffffffffffffffff166106f56105e3565b73ffffffffffffffffffffffffffffffffffffffff161461074b576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161074290610a26565b60405180910390fd5b565b60008060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050816000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055508173ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff167f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e060405160405180910390a35050565b600033905090565b600061082c61082784610a6b565b610a46565b9050808382526020820190508285602086028201111561084b57600080fd5b60005b8581101561087b57816108618882610885565b84526020840193506020830192505060018101905061084e565b5050509392505050565b60008135905061089481610c85565b92915050565b600082601f8301126108ab57600080fd5b81356108bb848260208601610819565b91505092915050565b6000813590506108d381610c9c565b92915050565b6000602082840312156108eb57600080fd5b60006108f984828501610885565b91505092915050565b60006020828403121561091457600080fd5b600082013567ffffffffffffffff81111561092e57600080fd5b61093a8482850161089a565b91505092915050565b60006020828403121561095557600080fd5b6000610963848285016108c4565b91505092915050565b61097581610adc565b82525050565b61098481610aee565b82525050565b6000610997602683610a97565b91506109a282610c0d565b604082019050919050565b60006109ba602083610a97565b91506109c582610c5c565b602082019050919050565b60006020820190506109e5600083018461096c565b92915050565b6000602082019050610a00600083018461097b565b92915050565b60006020820190508181036000830152610a1f8161098a565b9050919050565b60006020820190508181036000830152610a3f816109ad565b9050919050565b6000610a50610a61565b9050610a5c8282610b24565b919050565b6000604051905090565b600067ffffffffffffffff821115610a8657610a85610bcd565b5b602082029050602081019050919050565b600082825260208201905092915050565b6000610ab382610b1a565b9150610abe83610b1a565b925082821015610ad157610ad0610b9e565b5b828203905092915050565b6000610ae782610afa565b9050919050565b60008115159050919050565b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b6000819050919050565b610b2d82610bfc565b810181811067ffffffffffffffff82111715610b4c57610b4b610bcd565b5b80604052505050565b6000610b6082610b1a565b91507fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff821415610b9357610b92610b9e565b5b600182019050919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b7f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b6000601f19601f8301169050919050565b7f4f776e61626c653a206e6577206f776e657220697320746865207a65726f206160008201527f6464726573730000000000000000000000000000000000000000000000000000602082015250565b7f4f776e61626c653a2063616c6c6572206973206e6f7420746865206f776e6572600082015250565b610c8e81610adc565b8114610c9957600080fd5b50565b610ca581610b1a565b8114610cb057600080fd5b5056fea26469706673582212204c7771271c66cb550359eaaa7ad519ad0589d5f49427671a08419eccd0d018d264736f6c63430008040033";

type WordChainAdminConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: WordChainAdminConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class WordChainAdmin__factory extends ContractFactory {
  constructor(...args: WordChainAdminConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override deploy(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<WordChainAdmin> {
    return super.deploy(overrides || {}) as Promise<WordChainAdmin>;
  }
  override getDeployTransaction(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(overrides || {});
  }
  override attach(address: string): WordChainAdmin {
    return super.attach(address) as WordChainAdmin;
  }
  override connect(signer: Signer): WordChainAdmin__factory {
    return super.connect(signer) as WordChainAdmin__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): WordChainAdminInterface {
    return new utils.Interface(_abi) as WordChainAdminInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): WordChainAdmin {
    return new Contract(address, _abi, signerOrProvider) as WordChainAdmin;
  }
}
