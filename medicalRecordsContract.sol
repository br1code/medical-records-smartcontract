pragma solidity ^0.5.0;

contract MedicalRecords {
    
    address[] private patients;
    
    struct MedicalRecord {
        uint age;
        string name;
        string bloodGroup;
        bool exists;
    }
    
    mapping(address => MedicalRecord) medicalRecords;
    
    mapping(address => string) accessRecords;
    
    event onMedicalRecordRequested(uint age, string name, string bloodGroup);
    
    function upsertMedicalRecord(address patient, uint age, string memory name, string memory bloodGroup) public {
        require(onlyMedicalRecordsOwner(patient));
        
        MedicalRecord storage medicalRecord = medicalRecords[patient];
        
        if (!medicalRecord.exists) {
            patients.push(patient);
        }
        
        medicalRecord.age = age;
        medicalRecord.name = name;
        medicalRecord.bloodGroup = bloodGroup;
        medicalRecord.exists = true;
    }
    
    function requestMedicalRecord(address patient, string memory name, string memory timeStamp) public {
        MedicalRecord storage medicalRecord = medicalRecords[patient];
        
        if (medicalRecord.exists) {
            string memory prevAccessRecord = accessRecords[patient];
            string memory newAccessRecord = string(abi.encodePacked(prevAccessRecord, timeStamp, ' ', name, ' - ')); 
            accessRecords[patient] = newAccessRecord;
            
            emit onMedicalRecordRequested(medicalRecord.age, medicalRecord.name, medicalRecord.bloodGroup);
        }
    }
    
    function getAccessRecords(address patient) view public returns (string memory) {
        require(onlyMedicalRecordsOwner(patient));
        return accessRecords[patient];
    }
    
    function onlyMedicalRecordsOwner(address patient) view private returns (bool) {
        return msg.sender == patient;
    }
}