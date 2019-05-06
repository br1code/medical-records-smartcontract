pragma solidity ^0.5.0;

contract MedicalRecords {

    struct MedicalRecord {
        uint age;
        string name;
        string bloodGroup;
        bool exists;
    }

    mapping(address => MedicalRecord) medicalRecords;

    mapping(address => string) accessRecords;

    event onMedicalRecordRequested(uint age, string name, string bloodGroup);

    function getMedicalRecord() public view returns (uint, string memory, string memory) {
        MedicalRecord storage medicalRecord = medicalRecords[msg.sender];

        return (medicalRecord.age, medicalRecord.name, medicalRecord.bloodGroup);
    }

    function upsertMedicalRecord(uint age, string memory name, string memory bloodGroup) public {

        MedicalRecord storage medicalRecord = medicalRecords[msg.sender];

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

    function getAccessRecords() public view returns (string memory) {
        return accessRecords[msg.sender];
    }

}