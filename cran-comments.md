
## Release summary

This is a minor release of the `{bagyo}` package.

* added R (>= 4.1.0) dependency for use of base pipe operator
* added CRAN DOI badge
* added 2021 and 2022 typhoon data
* added CITATION.cff
* added an unexported utility function to download cyclone reports

## Test environments
* local OS X install, R 4.5.2
* local ubuntu 24.04 install, R 4.5.2
* win-builder (devel, release, and old release)
* github actions windows-latest, r: release
* github actions macOS-latest, r: release
* github actions ubuntu-24.04, r: release, devel, old release
* rhub windows-latest r devel
* rhub ubuntu 24.04 r devel
* rhub macos-arm64 r devel
* mac-builder

## R CMD check results

### Local checks

0 errors | 0 warnings | 0 notes

### win-builder checks - devel and release

0 errors | 0 warnings | 0 notes

### win-builder checks - old release

0 errors | 0 warnings | 1 note

Author field differs from that derived from Authors@R
  Author:    'Ernest Guevarra [aut, cre, cph] (ORCID: <https://orcid.org/0000-0002-4887-4415>)'
  Authors@R: 'Ernest Guevarra [aut, cre, cph] (<https://orcid.org/0000-0002-4887-4415>)'

Both ORCID information are the same but formatted differently.

### GitHub Actions checks

0 errors | 0 warnings | 0 notes

### rhub checks

0 errors | 0 warnings | 0 notes

### macbuilder checks

0 errors | 0 warnings | 0 notes

## Reverse dependencies
`bagyo` doesn't have any downstream / reverse dependencies 
(see https://github.com/panukatan/bagyo/tree/main/revdep/cran.md)

