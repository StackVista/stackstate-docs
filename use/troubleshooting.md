# Troubleshooting

## Known issues

### Topology perspective - `Resources are low`

**Symptom:** Resources are low message given on topology perspective screen, no topology visualization is displayed.

**Cause:** The GPU load on the machine displaying the StackState UI is too high.

**Possible solution:**
To successfully load the topology visualization, try the following:
* Reload the page.
* If the error returns or happens consistently, reduce the number of topology visualization windows open to avoid overloading the GPU.
