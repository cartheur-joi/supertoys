SHELL := /bin/bash

PROJECT := supertoys
DATE := $(shell date +%Y%m%d)

PROD_DIR := production
EXPORTS_DIR := $(PROD_DIR)/exports
MIX_DIR := $(PROD_DIR)/audio/mix

MASTER_MOV ?= $(EXPORTS_DIR)/$(PROJECT)_master.mov
FINAL_MP4 ?= $(EXPORTS_DIR)/$(PROJECT)_final.mp4
REVIEW_MP4 ?= $(EXPORTS_DIR)/$(PROJECT)_review.mp4
MIX_WAV ?= $(MIX_DIR)/$(PROJECT)_mix_v01.wav

.PHONY: help init check-tools review final audio-check status clean-review package onboard

help:
	@echo "Supertoys production helpers"
	@echo ""
	@echo "Targets:"
	@echo "  make onboard      - Print first-session onboarding checklist"
	@echo "  make init         - Create production folders"
	@echo "  make check-tools  - Verify required CLI tools are installed"
	@echo "  make review       - Encode a fast review MP4 from MASTER_MOV"
	@echo "  make final        - Encode a high-quality final MP4 from MASTER_MOV"
	@echo "  make audio-check  - Print loudness stats for MIX_WAV"
	@echo "  make status       - Show expected/available key files"
	@echo "  make package      - Zip docs + animatic specs for handoff"
	@echo "  make clean-review - Remove review and final MP4 outputs"
	@echo ""
	@echo "Overridable vars:"
	@echo "  MASTER_MOV='$(EXPORTS_DIR)/supertoys_master.mov' make final"
	@echo "  MIX_WAV='$(MIX_DIR)/supertoys_mix_v01.wav' make audio-check"

onboard:
	@cat docs/START_HERE.md

init:
	@./scripts/init_production.sh

check-tools:
	@./scripts/check_tools.sh

review:
	@./scripts/encode_review.sh "$(MASTER_MOV)" "$(REVIEW_MP4)"

final:
	@./scripts/encode_final.sh "$(MASTER_MOV)" "$(FINAL_MP4)"

audio-check:
	@./scripts/audio_check.sh "$(MIX_WAV)"

status:
	@echo "Project: $(PROJECT)"
	@echo "Date: $(DATE)"
	@echo ""
	@echo "Expected master video: $(MASTER_MOV)"
	@if [[ -f "$(MASTER_MOV)" ]]; then echo "  found"; else echo "  missing"; fi
	@echo "Expected mix wav: $(MIX_WAV)"
	@if [[ -f "$(MIX_WAV)" ]]; then echo "  found"; else echo "  missing"; fi
	@echo ""
	@echo "Core docs:"
	@for f in \
		docs/OPEN_SOURCE_ANIMATION_GUIDE_DEBIAN.md \
		story/supertoys-animated-screenplay.md \
		planning/supertoys-voice-actor-script.md \
		animatic/supertoys-edit-decision-list.csv; do \
		if [[ -f "$$f" ]]; then echo "  found $$f"; else echo "  missing $$f"; fi; \
	done

package:
	@mkdir -p "$(EXPORTS_DIR)"
	@zip -r "$(EXPORTS_DIR)/$(PROJECT)_docs_animatic_$(DATE).zip" \
		docs/ \
		story/ \
		planning/ \
		animatic
	@echo "Created $(EXPORTS_DIR)/$(PROJECT)_docs_animatic_$(DATE).zip"

clean-review:
	@rm -f "$(REVIEW_MP4)" "$(FINAL_MP4)"
	@echo "Removed review/final mp4 outputs."
