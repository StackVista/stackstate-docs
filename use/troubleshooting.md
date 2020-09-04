# Troubleshooting

## Known issues

### ERROR: Resources are low (topology perspective)

**Symptom:** Resources are low error message on topology perspective, no topology visualization is displayed.

**Cause:** The GPU load on the machine displaying the StackState UI is too high.

**Possible solution:** To resolve the error and load the topology visualization:
* Reload the page.
* If the error returns or happens consistently, reduce the number of topology visualization windows open to avoid overloading the GPU.
