// API
/// The URL the app should use to fetch the activity index.
const apiUrl = "http://localhost:8080/activity_index";


// Android & iOS only

// MQTT
const mqttHost = "192.168.178.107";
const mqttPort = 1883;
const mqttUsername = "admin";
const mqttPassword = "kogniuser";
const mqttTopic = "activity_index";

/// This controls whether the background service should be running constantly
/// as a foreground service or every 15 minutes as a worker.
///
/// If this is true, battery optimization must be disabled for this app on Android.
const continuousBackgroundService = true;