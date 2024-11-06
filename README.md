# tewke_task

A Task to be submitted to Tewke.
By: Zaafar Ahmad

## App

- GetX is being used for state management.
- Internet connectivity being checked on app launch.
- If no internet dedected. an action dialogue is displayed.
- The last updated value and time is shown until the internet restores.
- Shared Widget across app created for snackbar.


## Future Improvements

- Pull down to refresh can be added to improve user interface.
- After restoring the internet, if user resumes the app from background to foreground, the app can detects app lifecycle state and auto refreshes the data without being manually refreshed.
- Tabs can be added to fetch api data for 
    - past 24 hrs
    - future 48 hrs
    - future 24 hrs
- Weekly trajectory shown in another graph.