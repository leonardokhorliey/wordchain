/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PromiseOrValue } from "../../common";
import type {
  TokenManager,
  TokenManagerInterface,
} from "../../contracts/TokenManager";

const _abi = [
  {
    inputs: [
      {
        internalType: "address",
        name: "WCToken",
        type: "address",
      },
    ],
    stateMutability: "nonpayable",
    type: "constructor",
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
      {
        indexed: false,
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    name: "BuyTokens",
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
    inputs: [],
    name: "buyTokens",
    outputs: [],
    stateMutability: "payable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "string",
        name: "tournamentKey",
        type: "string",
      },
      {
        internalType: "address",
        name: "user",
        type: "address",
      },
    ],
    name: "getAmountStaked",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getETHBalance",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "user",
        type: "address",
      },
    ],
    name: "getTokenBalance",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getTokenDecimals",
    outputs: [
      {
        internalType: "uint8",
        name: "",
        type: "uint8",
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
    name: "hasStaked",
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
        name: "addr",
        type: "address",
      },
      {
        internalType: "string",
        name: "tournamentKey",
        type: "string",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "setUserStakingBalance",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "numOfTokens",
        type: "uint256",
      },
      {
        internalType: "string",
        name: "tournamentKey",
        type: "string",
      },
    ],
    name: "stakeToken",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    name: "stakers",
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
        internalType: "string",
        name: "",
        type: "string",
      },
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "stakingBalance",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "tokensPerEth",
    outputs: [
      {
        internalType: "uint8",
        name: "",
        type: "uint8",
      },
    ],
    stateMutability: "view",
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
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "transferTokens",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "wcToken",
    outputs: [
      {
        internalType: "contract WordChainToken",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
];

const _bytecode =
  "0x60806040523480156200001157600080fd5b5060405162001b3a38038062001b3a8339818101604052810190620000379190620001c3565b620000576200004b620000e060201b60201c565b620000e860201b60201c565b33600160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555080600260006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550506200023d565b600033905090565b60008060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050816000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055508173ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff167f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e060405160405180910390a35050565b600081519050620001bd8162000223565b92915050565b600060208284031215620001d657600080fd5b6000620001e684828501620001ac565b91505092915050565b6000620001fc8262000203565b9050919050565b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b6200022e81620001ef565b81146200023a57600080fd5b50565b6118ed806200024d6000396000f3fe6080604052600436106100f35760003560e01c8063bec3fa171161008a578063d0febe4c11610059578063d0febe4c1461032c578063efe3fe0114610336578063f2fde38b1461035f578063fd5e6dd114610388576100f3565b8063bec3fa171461025e578063c8a18cd714610287578063c93c8f34146102c4578063cbdd69b514610301576100f3565b80636e947298116100c65780636e947298146101c6578063715018a6146101f15780638da5cb5b14610208578063af2c37e814610233576100f3565b8063044b2d6c146100f85780630d1626531461013557806324f65ee71461015e5780633aecd0e314610189575b600080fd5b34801561010457600080fd5b5061011f600480360381019061011a9190610fe2565b6103c5565b60405161012c9190611355565b60405180910390f35b34801561014157600080fd5b5061015c60048036038101906101579190611088565b610400565b005b34801561016a57600080fd5b5061017361071a565b6040516101809190611370565b60405180910390f35b34801561019557600080fd5b506101b060048036038101906101ab9190610eed565b6107c1565b6040516101bd9190611355565b60405180910390f35b3480156101d257600080fd5b506101db610875565b6040516101e89190611355565b60405180910390f35b3480156101fd57600080fd5b5061020661087d565b005b34801561021457600080fd5b5061021d610891565b60405161022a9190611224565b60405180910390f35b34801561023f57600080fd5b506102486108ba565b60405161025591906112ba565b60405180910390f35b34801561026a57600080fd5b5061028560048036038101906102809190610f7d565b6108e0565b005b34801561029357600080fd5b506102ae60048036038101906102a99190610fe2565b610a58565b6040516102bb9190611355565b60405180910390f35b3480156102d057600080fd5b506102eb60048036038101906102e69190610eed565b610abe565b6040516102f8919061129f565b60405180910390f35b34801561030d57600080fd5b50610316610ade565b6040516103239190611370565b60405180910390f35b610334610ae3565b005b34801561034257600080fd5b5061035d60048036038101906103589190610f16565b610baa565b005b34801561036b57600080fd5b5061038660048036038101906103819190610eed565b610c0f565b005b34801561039457600080fd5b506103af60048036038101906103aa9190611036565b610c93565b6040516103bc9190611224565b60405180910390f35b600482805160208101820180518482526020830160208501208183528095505050505050602052806000526040600020600091509150505481565b60008211610443576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161043a90611335565b60405180910390fd5b6000600260009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1663313ce5676040518163ffffffff1660e01b815260040160206040518083038186803b1580156104ad57600080fd5b505afa1580156104c1573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906104e591906110dc565b9050600081600a6104f691906114b1565b8461050191906115cf565b9050600260009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff166370a08231336040518263ffffffff1660e01b815260040161055e9190611224565b60206040518083038186803b15801561057657600080fd5b505afa15801561058a573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906105ae919061105f565b8111156105f0576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016105e790611315565b60405180910390fd5b600260009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff166323b872dd3330846040518463ffffffff1660e01b815260040161064f9392919061123f565b602060405180830381600087803b15801561066957600080fd5b505af115801561067d573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906106a19190610fb9565b50806004846040516106b3919061120d565b908152602001604051809103902060003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600082825461070d9190611408565b9250508190555050505050565b6000600260009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1663313ce5676040518163ffffffff1660e01b815260040160206040518083038186803b15801561078457600080fd5b505afa158015610798573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906107bc91906110dc565b905090565b6000600260009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff166370a08231836040518263ffffffff1660e01b815260040161081e9190611224565b60206040518083038186803b15801561083657600080fd5b505afa15801561084a573d6000803e3d6000fd5b505050506040513d601f19601f8201168201806040525081019061086e919061105f565b9050919050565b600047905090565b610885610cd2565b61088f6000610d50565b565b60008060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff16905090565b600260009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b6108e8610cd2565b6000600260009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1663313ce5676040518163ffffffff1660e01b815260040160206040518083038186803b15801561095257600080fd5b505afa158015610966573d6000803e3d6000fd5b505050506040513d601f19601f8201168201806040525081019061098a91906110dc565b600a61099691906114b1565b826109a191906115cf565b9050600260009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1663a9059cbb84836040518363ffffffff1660e01b8152600401610a00929190611276565b602060405180830381600087803b158015610a1a57600080fd5b505af1158015610a2e573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610a529190610fb9565b50505050565b6000600483604051610a6a919061120d565b908152602001604051809103902060008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002054905092915050565b60056020528060005260406000206000915054906101000a900460ff1681565b601481565b6000601460ff1634610af591906115cf565b9050600260009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1663a9059cbb33836040518363ffffffff1660e01b8152600401610b54929190611276565b602060405180830381600087803b158015610b6e57600080fd5b505af1158015610b82573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610ba69190610fb9565b5050565b80600483604051610bbb919061120d565b908152602001604051809103902060008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002081905550505050565b610c17610cd2565b600073ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff161415610c87576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401610c7e906112d5565b60405180910390fd5b610c9081610d50565b50565b60038181548110610ca357600080fd5b906000526020600020016000915054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b610cda610e14565b73ffffffffffffffffffffffffffffffffffffffff16610cf8610891565b73ffffffffffffffffffffffffffffffffffffffff1614610d4e576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401610d45906112f5565b60405180910390fd5b565b60008060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050816000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055508173ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff167f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e060405160405180910390a35050565b600033905090565b6000610e2f610e2a846113b0565b61138b565b905082815260208101848484011115610e4757600080fd5b610e528482856116a2565b509392505050565b600081359050610e698161185b565b92915050565b600081519050610e7e81611872565b92915050565b600082601f830112610e9557600080fd5b8135610ea5848260208601610e1c565b91505092915050565b600081359050610ebd81611889565b92915050565b600081519050610ed281611889565b92915050565b600081519050610ee7816118a0565b92915050565b600060208284031215610eff57600080fd5b6000610f0d84828501610e5a565b91505092915050565b600080600060608486031215610f2b57600080fd5b6000610f3986828701610e5a565b935050602084013567ffffffffffffffff811115610f5657600080fd5b610f6286828701610e84565b9250506040610f7386828701610eae565b9150509250925092565b60008060408385031215610f9057600080fd5b6000610f9e85828601610e5a565b9250506020610faf85828601610eae565b9150509250929050565b600060208284031215610fcb57600080fd5b6000610fd984828501610e6f565b91505092915050565b60008060408385031215610ff557600080fd5b600083013567ffffffffffffffff81111561100f57600080fd5b61101b85828601610e84565b925050602061102c85828601610e5a565b9150509250929050565b60006020828403121561104857600080fd5b600061105684828501610eae565b91505092915050565b60006020828403121561107157600080fd5b600061107f84828501610ec3565b91505092915050565b6000806040838503121561109b57600080fd5b60006110a985828601610eae565b925050602083013567ffffffffffffffff8111156110c657600080fd5b6110d285828601610e84565b9150509250929050565b6000602082840312156110ee57600080fd5b60006110fc84828501610ed8565b91505092915050565b61110e81611629565b82525050565b61111d8161163b565b82525050565b61112c8161167e565b82525050565b600061113d826113e1565b61114781856113fd565b93506111578185602086016116b1565b80840191505092915050565b60006111706026836113ec565b915061117b82611791565b604082019050919050565b60006111936020836113ec565b915061119e826117e0565b602082019050919050565b60006111b66011836113ec565b91506111c182611809565b602082019050919050565b60006111d9601b836113ec565b91506111e482611832565b602082019050919050565b6111f881611667565b82525050565b61120781611671565b82525050565b60006112198284611132565b915081905092915050565b60006020820190506112396000830184611105565b92915050565b60006060820190506112546000830186611105565b6112616020830185611105565b61126e60408301846111ef565b949350505050565b600060408201905061128b6000830185611105565b61129860208301846111ef565b9392505050565b60006020820190506112b46000830184611114565b92915050565b60006020820190506112cf6000830184611123565b92915050565b600060208201905081810360008301526112ee81611163565b9050919050565b6000602082019050818103600083015261130e81611186565b9050919050565b6000602082019050818103600083015261132e816111a9565b9050919050565b6000602082019050818103600083015261134e816111cc565b9050919050565b600060208201905061136a60008301846111ef565b92915050565b600060208201905061138560008301846111fe565b92915050565b60006113956113a6565b90506113a182826116e4565b919050565b6000604051905090565b600067ffffffffffffffff8211156113cb576113ca611744565b5b6113d482611773565b9050602081019050919050565b600081519050919050565b600082825260208201905092915050565b600081905092915050565b600061141382611667565b915061141e83611667565b9250827fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0382111561145357611452611715565b5b828201905092915050565b6000808291508390505b60018511156114a85780860481111561148457611483611715565b5b60018516156114935780820291505b80810290506114a185611784565b9450611468565b94509492505050565b60006114bc82611667565b91506114c783611671565b92506114f47fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff84846114fc565b905092915050565b60008261150c57600190506115c8565b8161151a57600090506115c8565b8160018114611530576002811461153a57611569565b60019150506115c8565b60ff84111561154c5761154b611715565b5b8360020a91508482111561156357611562611715565b5b506115c8565b5060208310610133831016604e8410600b841016171561159e5782820a90508381111561159957611598611715565b5b6115c8565b6115ab848484600161145e565b925090508184048111156115c2576115c1611715565b5b81810290505b9392505050565b60006115da82611667565b91506115e583611667565b9250817fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff048311821515161561161e5761161d611715565b5b828202905092915050565b600061163482611647565b9050919050565b60008115159050919050565b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b6000819050919050565b600060ff82169050919050565b600061168982611690565b9050919050565b600061169b82611647565b9050919050565b82818337600083830152505050565b60005b838110156116cf5780820151818401526020810190506116b4565b838111156116de576000848401525b50505050565b6116ed82611773565b810181811067ffffffffffffffff8211171561170c5761170b611744565b5b80604052505050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b7f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b6000601f19601f8301169050919050565b60008160011c9050919050565b7f4f776e61626c653a206e6577206f776e657220697320746865207a65726f206160008201527f6464726573730000000000000000000000000000000000000000000000000000602082015250565b7f4f776e61626c653a2063616c6c6572206973206e6f7420746865206f776e6572600082015250565b7f4e6f7420656e6f75676820746f6b656e73000000000000000000000000000000600082015250565b7f537570706c792076616c7565206c657373207468616e207a65726f0000000000600082015250565b61186481611629565b811461186f57600080fd5b50565b61187b8161163b565b811461188657600080fd5b50565b61189281611667565b811461189d57600080fd5b50565b6118a981611671565b81146118b457600080fd5b5056fea2646970667358221220b8c3a25f3abb682a2bff45a3d89b0270c3900aff7b09780279ac82730137a19b64736f6c63430008040033";

type TokenManagerConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: TokenManagerConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class TokenManager__factory extends ContractFactory {
  constructor(...args: TokenManagerConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override deploy(
    WCToken: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<TokenManager> {
    return super.deploy(WCToken, overrides || {}) as Promise<TokenManager>;
  }
  override getDeployTransaction(
    WCToken: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(WCToken, overrides || {});
  }
  override attach(address: string): TokenManager {
    return super.attach(address) as TokenManager;
  }
  override connect(signer: Signer): TokenManager__factory {
    return super.connect(signer) as TokenManager__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): TokenManagerInterface {
    return new utils.Interface(_abi) as TokenManagerInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): TokenManager {
    return new Contract(address, _abi, signerOrProvider) as TokenManager;
  }
}
