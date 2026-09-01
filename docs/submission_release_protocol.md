# Submission release and archive protocol

Status: pre-submission infrastructure only. No package is frozen, tagged,
archived, uploaded, or submitted by this document.

## Preconditions

Do not build a release manifest until all of the following are true:

- issue #30 has an explicit include/defer decision;
- every applicable row in
  `manuscript/isme_communications/author_decision_register.tsv` is completed by
  its named human owner;
- the selected journal's authorship and AI-use policy is satisfied;
- the researcher-authored manuscript and declarations are final;
- issue #33 records coauthor review and explicit corresponding-author approval;
- the complete audit and visual review pass on the exact frozen files;
- the repository is clean and the freeze commit is pushed.

## Approved inventory contract

Create a tab-separated inventory outside the repository with exactly these
columns:

```text
role	source_path	submission_name	approval_status
```

Every row must use `approved_by_corresponding_author` as the approval status.
The source must be the exact file reviewed by the authors. Submission names
must be unique basenames without directory separators. The inventory should
include the manuscript, title page if separate, cover letter, every main figure,
every supplementary file, graphical abstract or featured image, and any portal
attachment that must be archived.

## Byte-addressed manifest

Run:

```sh
bash scripts/build_submission_release_manifest.sh \
  /path/to/approved_inventory.tsv \
  /path/to/release/submission_release_manifest.tsv
```

The command refuses an existing output, an incomplete or malformed inventory,
any unapproved row, duplicate or unsafe submission names, and missing source
files. It writes atomically only after validation. Each output row records the
role, submission filename, exact source path, byte count, SHA-256 checksum,
repository commit, and UTC generation time.

This manifest does not submit, copy, rename, compress, tag, archive, or upload
anything. It only binds the author-approved files to exact bytes.

## Portal transformation log

If the journal portal renames, converts, combines, or regenerates a file, record
the original checksum, transformed filename, downloaded proof checksum, portal
action, responsible person, and UTC time. Never claim byte identity when the
portal has transformed a file.

## Release and archive boundary

Only after the corresponding author approves the byte-addressed manifest:

1. create the immutable repository tag at the recorded commit;
2. archive the exact approved files and manifest in the authorized persistent
   repository;
3. record the release DOI or persistent identifier;
4. submit through the selected journal portal;
5. download and checksum the submission proof and confirmation;
6. record the manuscript identifier and post-submission responsibilities in the
   controlling handoff.

These are live external actions. Each requires the authority specified in issue
#34; preparing this protocol does not grant that authority.
