# Changelog

<!--
Prefix your message with one of the following:

- [Added] for new features.
- [Changed] for changes in existing functionality.
- [Deprecated] for soon-to-be removed features.
- [Removed] for now removed features.
- [Fixed] for any bug fixes.
- [Security] in case of vulnerabilities.
-->

## Unreleased

- [Added] `page_meta.base` will now set the base url.
- [Changed] Some tags will be enforced to show up first. It loosely follows 
  https://rviscomi.github.io/capo.js/user/rules/.

## 1.2.0

- [Added] The meta tag's content can also be any object that responds to the
  method `call`, like procs.
- [Fixed] Fixed case where meta tags were being rendered with blank content.

## 1.1.0

- [Added] `<meta name="viewport" content="width=device-width,initial-scale=1">`
  is now added by default.
- [Changed] You can now group all translations under
  `page_meta.controller.action.{title,description,keywords}`.

## 1.0.0

- Initial release.
