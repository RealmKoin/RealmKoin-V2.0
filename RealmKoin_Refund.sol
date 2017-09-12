pragma solidity ^0.4.11;
// @library: solidity
// RealmKoin Refund Contract.
// Author: Skrypt
// GitHub: Www.Github.com/RealmKoin
// GitLab: git.techenterprises.me
// ProjectWeb: Www.RealmKoin.com
// SourceWeb: Www.TechEnterprises.me
// License Standard T.G.L(D: 2017) (The Guild License (Version Date: 2017*))
// (* Any And All Revised Future Editorials Of T.G.L Apply From 1/1/2017 To Date.)
// RealmKoin Ethereum Refund Smart Contract.
// Smart Contract That Has 0 Authorization To The RealmKoin Network. 
// Sends Ethereum From Refunds / Donations Account To Specified Address
// Appendable Ion For Network Connections.
// Ion Refund // Collect Donations Functions.
// RealmKoin Network Contracts Are Public And RealmKoin Team Deployed ONLY.
// This Contract Requires Authenticated Callers But Has No Authority Within The Network.
// Fallback () Function Refers To Donations.

// Usage Extended To Public At A Later Date.

// Contract Definition Below:
contract RealmKoin_Refund {
    address public Donations_Contract;
    address public Stat_Signature;
    uint public Total_Ions;
    uint public Active_Ions;
    bool public Donations_Contract_Set;
    bool private do_nothing;
    uint256 public Donations;
    uint256 public Total_Donations;
    uint256 public Refunds;

// Structures Below:
    struct network_data {
        bool Ion;
        bool Stat;
    }

    struct ion_data {
        address Ion_Signature;
    }

// Mappings Below: 
    mapping(address => network_data) public Network;
    mapping(uint => ion_data) public Ion_Data;

// Events Below:
    event Donations_Withdrawn(address _IonSig, address _To, uint _MsgValue);
    event Refunded(address _To, uint _MsgValue);
    event Donation_Received(address _SenderSig, uint _MsgValue);
    event Set_Donations_Address(address _IonSig, address _DonationAddress);
    event Refunds_Accepted(address _SenderSig, uint256 _MsgValue);
    event MsgValue_Needed(address _CallerSig);
    event MsgValue_Accepted(address _MsgValueSender);
    event Refunds_Unavailable(address _IonSig, uint256 _Refunds);
    event Donations_Unavailable(address _IonSig, uint256 _Donations);
    event Not_On_Network(address _CallerSig);
    event Stat_Only_Option(address _CallerSig);
    event Ion_Linked(address _IonLinked);
    event Ion_UnLinked(address _IonUnlinked);
    event Stat_Assigned(address _OldStat, address _NewStat);

// Modifiers Below:
    modifier Is_Sender_Ion() {
        if (Network[msg.sender].Ion != true) {
            do_nothing = true;
            Not_On_Network(msg.sender);
        }
        _;
    }
    modifier Is_Sender_Stat() {
        if (Network[msg.sender].Stat != true) {
            do_nothing = true;
            Stat_Only_Option(msg.sender);
        }
        _;
    }
    modifier Value_Needed() {
        if (msg.value == 0) {
            do_nothing = true;
            MsgValue_Needed(msg.sender);
        }
        _;
    }
    modifier Are_Refunds_Available(uint256 _value) {
        if (Refunds < _value) {
            do_nothing = true;
            Refunds_Unavailable(msg.sender, Refunds);
        }
        _;
    }
    modifier Are_Donations_Available(uint256 _value) {
        if (Donations < _value) {
            do_nothing = true;
            Donations_Unavailable(msg.sender, Donations);
        }
        _;
    }

    modifier MsgValue() {
        if (msg.value > 0) {
            do_nothing = false;
            Donations += msg.value;
            Total_Donations += msg.value;
            MsgValue_Accepted(msg.sender);
        }
        _;
    }
    function RealmKoin_Refund(address _Stat) {
        Donations = 0;
        Total_Donations = 0;
        Refunds = 0;
        Total_Ions = 0;
        Active_Ions = 0;
        Donations_Contract_Set = false;
        Network[msg.sender].Ion = true;
        Ion_Data[Total_Ions].Ion_Signature = msg.sender;
        Total_Ions += 1;
        Active_Ions += 1;
        Network[_Stat].Ion = true;
        Network[_Stat].Stat = true;
        Ion_Data[Total_Ions].Ion_Signature = _Stat;
        Total_Ions += 1;
        Active_Ions += 1;
        do_nothing = false;
    }
    function Link_Ion(address _NewIon) public payable
     MsgValue()
     Is_Sender_Stat() 
     returns (bool sucess)
    {
     if (do_nothing == true)
     {
         do_nothing = false;
         return false;
     }
     else
     {
         Network[_NewIon].Ion = true;
         Ion_Data[Total_Ions].Ion_Signature = _NewIon;
         Total_Ions += 1;
         Active_Ions += 1;
         Ion_Linked(_NewIon);
         return true;
     }
    }
    function Unlink_Ion(address _IonName) public payable
     MsgValue()
     Is_Sender_Stat()
     returns (bool success)
    {
     if (do_nothing == true)
     {
         do_nothing = false;
         return false;
     }
     else
     {
        Network[_IonName].Ion = false;
        Active_Ions -= 1;
        Ion_UnLinked(_IonName);
        return true;
     }
    }
    
    function Fill_Refunds() public payable
     Is_Sender_Ion()
     Value_Needed()
     returns (bool success)
    {
     if (do_nothing == true)
     {
         do_nothing = false;
         return false;
     }
     else
     {
        Refunds += msg.value;
        Refunds_Accepted(msg.sender, msg.value);
        return true;
     }
    }


    function Refund(address _to, uint256 _value) public payable
     MsgValue()
     Is_Sender_Ion()
     Are_Refunds_Available(_value)
     returns (bool sucess)
    {
     if (do_nothing == true)
     {
         do_nothing = false;
         return false;
     }
     else
     {
        if (!_to.call.value(_value)()) {
            return false;
        }
        else
        {
            Refunded(_to, _value);
            Refunds -= _value;
            return true;
        }
     }
    }

    function Collect_Donations(address _to, uint256 _value) public payable
     MsgValue()
     Is_Sender_Ion()
     Are_Donations_Available(_value) 
     returns (bool sucess)
    {
     if (do_nothing == true)
     {
         do_nothing = false;
         return false;
     }
     else
     {
        if (!_to.call.value(_value)()) {
            return false;
        }
        else
        {
            Donations_Withdrawn(msg.sender, _to, _value);
            Donations -= _value;
            return true;
        }
     }
    }

    function Set_Donations_Contract(address _DonationDestination) public payable
     MsgValue()
     Is_Sender_Stat() 
     returns (bool sucess)
    {
     if (do_nothing == true)
     {
         do_nothing = false;
         return false;
     }
     else
     {
        Donations_Contract = _DonationDestination;
        Donations_Contract_Set = true;
        Set_Donations_Address(msg.sender, _DonationDestination);
        return true;
     }
    }

    function Assign_Stat(address _NewStat)
     public payable
     MsgValue()
     Is_Sender_Stat()
     returns (bool success)
     {
         if (do_nothing == true) {
             do_nothing = false;
             return false;
         }
         else
         {
             Network[msg.sender].Stat = false;
             Network[msg.sender].Ion = false;
             Stat_Signature = _NewStat;
             Network[_NewStat].Stat = true;
             Network[_NewStat].Ion = true;
             Stat_Assigned(msg.sender, _NewStat);
             return true;
         }
     }
    
    function Disengage(address _Beneficiary) public 
     Is_Sender_Stat()
     returns (bool success)
     {
      if (do_nothing == true) 
      {
          do_nothing = false;
          return false;
      }
      else
      {
          selfdestruct(_Beneficiary);
      }
     }
    function() payable 
    {
      if (Donations_Contract_Set == true) {
       if (!Donations_Contract.call.value(msg.value)()) {
            Total_Donations += msg.value;
            Donation_Received(msg.sender, msg.value);
       }
      }
      else
      {
       Total_Donations += msg.value;
       Donations += msg.value;
       Donation_Received(msg.sender, msg.value);
      } 
    }
}
