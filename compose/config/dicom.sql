/*
#       DICOM Database layout
#     Example version for all SQL servers (mostly normalized)
#
#	(File DICOM.SQL)
#	** DO NOT EDIT THIS FILE UNLESS YOU KNOW WHAT YOU ARE DOING **
#
#	Version with modality moved to the series level and EchoNumber in image table
#	Revision 3: Patient birthday and sex, bolus agent, correct field lengths
#	Revision 4: Studymodality, Station and Department in study
#	            Manufacturer, Model, BodyPart and Protocol in series
#	            Acqdate/time, coil, acqnumber, slicelocation and pixel info in images
#       Notes for revision 4:
#         InstitutionalDepartmentName in study (should officially be in series, but eFilm expects it in study)
#         StationName is in study              (should officially be in series, but more useful in study)
#	Revision 5: Added patientID in series and images for more efficient querying
#	Revision 6: Added frame of reference UID in series table
#	Revision 7: Added ImageType in image table, StudyModality to 64 chars, AcqDate to SQL_C_DATE
#	Revision 8: Denormalized study table (add patient ID, name, birthdate) to show consistency problems
#	Revision 10: Fixed width of ReceivingCoil: to 16 chars
#	Revision 13: Added ImageID to image database
#	Revision 14: Added WorkList database with HL7 tags
#	Revision 16: Moved Stationname and InstitutionalDepartmentName to series table
#	Revision 17: EchoNumber, ReqProcDescription to 64 characters; StudyModality, EchoNumber, ImageType to DT_MSTR; use Institution instead of InstitutionalDepartmentName
#	Revision 18: DT_STR can now be replaced by DT_ISTR to force case insensitive searches
#
#
#	5 databases need to be defined:
#
#		*Patient*
#			*Study*
#				*Series*
#					*Image*
#			*WorkList*
#
#
# The last defined element of Study is a link back to Patient
# The last defined element of Series is a link back to Study
# The last defined element of Image is a link back to Series
#
#
# Format for DICOM databases :
#	{ Group, Element, Column Name, Column Length, SQL-Type, DICOM-Type }
# Format for Worklist database :
#	{ Group, Element, Column Name, Column Length, SQL-Type, DICOM-Type, HL7 tag}
#	HL7 tags include SEQ.N, SEQ.N.M, SEQ.N.DATE, SEQ.N.TIME, *AN, *UI
*/

*Patient*
{
	{ 0x0010, 0x0020, "PatientID", 64, SQL_C_CHAR, DT_STR },
	{ 0x0010, 0x0010, "PatientName", 64, SQL_C_CHAR, DT_STR },
        { 0x0010, 0x0030, "PatientBirthDate", 8, SQL_C_DATE, DT_DATE },
	{ 0x0010, 0x0040, "PatientSex", 16, SQL_C_CHAR, DT_STR }
}

*Study*
{
	{ 0x0020, 0x000d, "StudyInstanceUID", 64, SQL_C_CHAR, DT_UI },
	{ 0x0008, 0x0020, "StudyDate", 8, SQL_C_DATE, DT_DATE },
	{ 0x0008, 0x0030, "StudyTime", 16, SQL_C_CHAR, DT_TIME },
	{ 0x0020, 0x0010, "StudyID", 16, SQL_C_CHAR, DT_STR },
	{ 0x0008, 0x1030, "StudyDescription", 64, SQL_C_CHAR, DT_STR },
	{ 0x0008, 0x0050, "AccessionNumber", 16, SQL_C_CHAR, DT_STR },
	{ 0x0008, 0x0090, "ReferPhysician", 64, SQL_C_CHAR, DT_STR },
	{ 0x0010, 0x1010, "PatientsAge", 16, SQL_C_CHAR, DT_STR },
	{ 0x0010, 0x1030, "PatientsWeight", 16, SQL_C_CHAR, DT_STR },
	{ 0x0008, 0x0061, "StudyModality", 64, SQL_C_CHAR, DT_MSTR },

	{ 0x0010, 0x0010, "PatientName", 64, SQL_C_CHAR, DT_STR },
        { 0x0010, 0x0030, "PatientBirthDate", 8, SQL_C_DATE, DT_DATE },
	{ 0x0010, 0x0040, "PatientSex", 16, SQL_C_CHAR, DT_STR }

	{ 0x0010, 0x0020, "PatientID", 64, SQL_C_CHAR, DT_STR }
}

*Series*
{
	{ 0x0020, 0x000e, "SeriesInstanceUID", 64, SQL_C_CHAR, DT_UI },
	{ 0x0020, 0x0011, "SeriesNumber", 12, SQL_C_CHAR, DT_STR },
	{ 0x0008, 0x0021, "SeriesDate", 8, SQL_C_DATE, DT_DATE },
	{ 0x0008, 0x0031, "SeriesTime", 16, SQL_C_CHAR, DT_TIME },
	{ 0x0008, 0x103e, "SeriesDescription", 64, SQL_C_CHAR, DT_STR },
	{ 0x0008, 0x0060, "Modality", 16, SQL_C_CHAR, DT_STR },
	{ 0x0018, 0x5100, "PatientPosition", 16, SQL_C_CHAR, DT_STR },
	{ 0x0018, 0x0010, "ContrastBolusAgent", 64, SQL_C_CHAR, DT_STR },
	{ 0x0008, 0x0070, "Manufacturer", 64, SQL_C_CHAR, DT_STR },
	{ 0x0008, 0x1090, "ModelName", 64, SQL_C_CHAR, DT_STR },
	{ 0x0018, 0x0015, "BodyPartExamined", 64, SQL_C_CHAR, DT_STR },
	{ 0x0018, 0x1030, "ProtocolName", 64, SQL_C_CHAR, DT_STR },
	{ 0x0008, 0x1010, "StationName", 16, SQL_C_CHAR, DT_STR },
	{ 0x0008, 0x0080, "Institution", 64, SQL_C_CHAR, DT_STR },
	{ 0x0020, 0x0052, "FrameOfReferenceUID", 64, SQL_C_CHAR, DT_UI },
	{ 0x0010, 0x0020, "SeriesPat", 64, SQL_C_CHAR, DT_STR },
	{ 0x0020, 0x000d, "StudyInstanceUID", 64, SQL_C_CHAR, DT_UI }
}

*Image*
{
	{ 0x0008, 0x0018, "SOPInstanceUID", 64, SQL_C_CHAR, DT_UI },
	{ 0x0008, 0x0016, "SOPClassUID", 64, SQL_C_CHAR, DT_UI },
	{ 0x0020, 0x0013, "ImageNumber", 12, SQL_C_CHAR, DT_STR },
	{ 0x0008, 0x0023, "ImageDate", 8, SQL_C_DATE, DT_DATE },
	{ 0x0008, 0x0033, "ImageTime", 16, SQL_C_CHAR, DT_TIME },
	{ 0x0018, 0x0086, "EchoNumber", 64, SQL_C_CHAR, DT_MSTR },
	{ 0x0028, 0x0008, "NumberOfFrames", 12, SQL_C_CHAR, DT_STR },
	{ 0x0008, 0x0022, "AcqDate", 8, SQL_C_DATE, DT_DATE },
	{ 0x0008, 0x0032, "AcqTime", 16, SQL_C_CHAR, DT_TIME },
	{ 0x0018, 0x1250, "ReceivingCoil", 16, SQL_C_CHAR, DT_STR },
	{ 0x0020, 0x0012, "AcqNumber", 12, SQL_C_CHAR, DT_STR },
	{ 0x0020, 0x1041, "SliceLocation", 16, SQL_C_CHAR, DT_STR },
	{ 0x0028, 0x0002, "SamplesPerPixel", 5, SQL_C_CHAR, DT_UINT16 },
	{ 0x0028, 0x0004, "PhotoMetricInterpretation", 16, SQL_C_CHAR, DT_STR },
	{ 0x0028, 0x0010, "Rows", 5, SQL_C_CHAR, DT_UINT16 },
	{ 0x0028, 0x0011, "Colums", 5, SQL_C_CHAR, DT_UINT16 },
	{ 0x0028, 0x0101, "BitsStored", 5, SQL_C_CHAR, DT_UINT16 },
	{ 0x0008, 0x0008, "ImageType", 128, SQL_C_CHAR, DT_MSTR },
	{ 0x0054, 0x0400, "ImageID", 16, SQL_C_CHAR, DT_STR },
	{ 0x0010, 0x0020, "ImagePat", 64, SQL_C_CHAR, DT_STR },
	{ 0x0020, 0x000e, "SeriesInstanceUID", 64, SQL_C_CHAR, DT_UI }
}

*WorkList*
{
 	{ 0x0008, 0x0050, "AccessionNumber",    16, SQL_C_CHAR, DT_STR,  "OBR.3" },
 	{ 0x0010, 0x0020, "PatientID",          64, SQL_C_CHAR, DT_STR,  "PID.4" },
 	{ 0x0010, 0x0010, "PatientName",        64, SQL_C_CHAR, DT_STR,  "PID.5" },
        { 0x0010, 0x0030, "PatientBirthDate",    8, SQL_C_DATE, DT_DATE, "PID.7" },
 	{ 0x0010, 0x0040, "PatientSex",         16, SQL_C_CHAR, DT_STR,  "PID.8" },

 	{ 0x0010, 0x2000, "MedicalAlerts",      64, SQL_C_CHAR, DT_STR,  "---" },
 	{ 0x0010, 0x2110, "ContrastAllergies",  64, SQL_C_CHAR, DT_STR,  "---" },
 	{ 0x0020, 0x000d, "StudyInstanceUID",   64, SQL_C_CHAR, DT_UI,   "---" },
 	{ 0x0032, 0x1032, "ReqPhysician",       64, SQL_C_CHAR, DT_STR,  "OBR.16" },
 	{ 0x0032, 0x1060, "ReqProcDescription", 64, SQL_C_CHAR, DT_STR,  "OBR.4.1" },

 	{ 0x0040, 0x0100, "--------",   0, SQL_C_CHAR, DT_STARTSEQUENCE, "---" },
 	{ 0x0008, 0x0060, "Modality",           16, SQL_C_CHAR, DT_STR,  "OBR.21" },
 	{ 0x0032, 0x1070, "ReqContrastAgent",   64, SQL_C_CHAR, DT_STR,  "---" },
 	{ 0x0040, 0x0001, "ScheduledAE",        16, SQL_C_CHAR, DT_STR,  "---" },
 	{ 0x0040, 0x0002, "StartDate",           8, SQL_C_DATE, DT_DATE, "OBR.7.DATE" },
 	{ 0x0040, 0x0003, "StartTime",          16, SQL_C_CHAR, DT_TIME, "OBR.7.TIME" },
 	{ 0x0040, 0x0006, "PerfPhysician",      64, SQL_C_CHAR, DT_STR,  "---" },
 	{ 0x0040, 0x0007, "SchedPSDescription", 64, SQL_C_CHAR, DT_STR,  "---" },
 	{ 0x0040, 0x0009, "SchedPSID",          16, SQL_C_CHAR, DT_STR,  "OBR.4" },
 	{ 0x0040, 0x0010, "SchedStationName",   16, SQL_C_CHAR, DT_STR,  "OBR.24" },
 	{ 0x0040, 0x0011, "SchedPSLocation",    16, SQL_C_CHAR, DT_STR,  "---" },
 	{ 0x0040, 0x0012, "PreMedication",      64, SQL_C_CHAR, DT_STR,  "---" },
 	{ 0x0040, 0x0400, "SchedPSComments",    64, SQL_C_CHAR, DT_STR,  "---" },
 	{ 0x0040, 0x0100, "---------",    0, SQL_C_CHAR, DT_ENDSEQUENCE, "---" },

        { 0x0040, 0x1001, "ReqProcID",          16, SQL_C_CHAR, DT_STR,  "OBR.4.0" },
 	{ 0x0040, 0x1003, "ReqProcPriority",    16, SQL_C_CHAR, DT_STR,  "OBR.27" }
}
