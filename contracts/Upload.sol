// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Upload
{
    struct Access
    {
        address user; // stores the address of another user which will have the access to current user's images
        bool access; // tells yes or no 
    }
    mapping(address=>string[]) value; // stores address of various URL of images on IPFS of current user
    mapping(address=>mapping(address=>bool)) ownership; //manages ownership between 2 users
    mapping(address=>Access[]) accessList; // stores list of users with its access state
    mapping(address=>mapping(address=>bool)) prevData;

    function addURL(address user_, string memory url) external 
    {
        value[user_].push(url);
    }

     function allow(address user) external  // manipulation with access of 'user' of msg.sender's data
     {
      ownership[msg.sender][user]=true; 
      if(prevData[msg.sender][user]) //deals with the case where node of user already exists in msg.sender's access list
      {
         for(uint i=0;i<accessList[msg.sender].length;i++)
        {
             if(accessList[msg.sender][i].user==user)
                { 
                  accessList[msg.sender][i].access=true; 
                }
        }
      }
      else // deals when a new node is to be assigned for address
       {
          accessList[msg.sender].push(Access(user,true));  
          prevData[msg.sender][user]=true;  
       }
    
    }

    function disallow(address user) public
    {
      ownership[msg.sender][user]=false;
      for(uint i=0;i<accessList[msg.sender].length;i++)
        {
          if(accessList[msg.sender][i].user==user)
            { 
              accessList[msg.sender][i].access=false;  
            }
        }
    } 

   function display(address user_) external view returns(string[] memory) //access of user's content by msg.sender
    {
      require(user_==msg.sender || ownership[user_][msg.sender],"Dear user, you aren't allowed to access this content.");
      return value[user_];
    }

  function shareAccess() public view returns(Access[] memory) // display accesList
    {
      return accessList[msg.sender];
    } 

}

//0x5FbDB2315678afecb367f032d93F642f64180aa3 (library deployed here)