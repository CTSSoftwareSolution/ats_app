

import '../Data/model/bottom_nav_model.dart';
import '../Data/model/list_model.dart';
import '../Data/model/profile_model.dart';

const atsLogo = "assets/ats_logo.png";
const gvtLogo = "assets/gvm_maharashtra.png";
const ceriseLogo = "assets/cerise_logo.png";
const logoImage = "assets/logo.png";
const appLogoImage = "assets/app-logo.png";
const homeIcon = "assets/home.png";
const profileIcon = "assets/profile.png";
const resultIcon = "assets/result.png";
const walletIcon = "assets/wallet.png";
const heartIcon = "assets/heart.png";
const dividerImage = "assets/divider.png";
const defaultImage = "assets/default-image.png";
const passImage = "assets/pass-image.png";
const failImage = "assets/fail-image.png";
const backArrowIcon = "assets/back-arrow.png";
const petrolIcon = "assets/petrol.png";
const noImage = "assets/no-image.png";
const searchIcon = "assets/search-icon.png";
const closeIcon = "assets/close-icon.png";
const uploadIcon = "assets/upload-icon.png";
const cameraIcon = "assets/camera-icon.png";
const galleryIcon = "assets/gallery-icon.png";
const cameraBackArrow = "assets/camera-back-arrow.png";
const cameraButtonIcon = "assets/camera_button.png";
const vehicleIcon = "assets/vehicle.png";
const logoutIcon = "assets/logout.png";
const emptyBoxImage = "assets/empty-box.png";
const userImage = "assets/user.png";
const editIcon = "assets/edit.png";
const editProfileIcon = "assets/edit_profile.png";
const forwardIcon = "assets/forward_icon.png";
const versionControlIcon = "assets/version.png";
const contactUsIcon = "assets/contact-us.png";
const termsIcon = "assets/terms-conditions.png";
const privacyIcon = "assets/privacy-policy.png";
const notificationIcon = "assets/notification.png";
const noDataIcon = "assets/no-data.png";
const photoCaptureIcon = "assets/photo-capture.png";
const vehicleNumberPlateImage = "assets/vehicle_number_plate.png";
const carNumberPlateImage = "assets/car_number_plate.png";

const manualInspectionIcon = "assets/manual-inspection.png";
const machineInspectionIcon = "assets/machine-inspection.png";


final List<String> vehicleGridTitles = <String>[
  "LCV",
  "LMV",
  "EV",
  "HCV",
];

final List<String> inspectionTypeImage = <String>[
  manualInspectionIcon,
  machineInspectionIcon,
];

final List<String> vehicleGridImages = <String>[
  "assets/vehicle-image/blue-car.jpg",
  "assets/vehicle-image/white-car.jpg",
  "assets/vehicle-image/white-truck.jpg",
  "assets/vehicle-image/bike.jpg",
];

List<ListModel> mediaSource = [
  const ListModel(0, 'Camera', cameraIcon),
  const ListModel(1, 'Gallery',galleryIcon),
];


List<ProfileModel> profileGridValues = [
  const ProfileModel(0, 'Personal Details','View your personal details',editProfileIcon,ProfileTrailingType.arrow),
  const ProfileModel(1, 'Notification','Manage your alerts and notifications',notificationIcon,ProfileTrailingType.switchButton),
  const ProfileModel(2, 'Privacy Policy','Learn how we protect your data',privacyIcon,ProfileTrailingType.arrow),
  const ProfileModel(3, 'Terms & Conditions','Our rules, explained simply',termsIcon,ProfileTrailingType.arrow),
  const ProfileModel(4, 'Contact Us','We are here, if you need any help',contactUsIcon,ProfileTrailingType.arrow),
  const ProfileModel(5, 'Ip Config','Change Ip Address to access',logoutIcon,ProfileTrailingType.none),
  const ProfileModel(6, 'Logout','Sign out safely and easily',logoutIcon,ProfileTrailingType.none),
  const ProfileModel(7, '','',versionControlIcon,ProfileTrailingType.none),
];



List<BottomNavModel> bottomNavValue = [
  BottomNavModel(0, "Home", homeIcon),
  BottomNavModel(1, "Result", resultIcon),
  BottomNavModel(2, "Type", vehicleIcon),
  BottomNavModel(3, "Profile", profileIcon),
];

List<String> labels = [
  "Front Photo",
  "Rear Photo",
  "Left Side Photo",
  "Right Side Photo",
  "Engine",
  "Dashboard Photo",
  "Bottom Photo",
  "Chassis Number Photo",

];