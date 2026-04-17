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

.PHONY: help init check-tools review final audio-check status clean-review package onboard sync-master watch-master lookdev-init script-stills-sync comfy-bootstrap comfy-p17 comfy-p17-fast comfy-p17-hq comfy-p07 comfy-p07-fast comfy-p07-hq comfy-p25 comfy-p25-fast comfy-p25-hq comfy-run-cpu-strong submission-init submission-check submission-package plan-8week

help:
	@echo "Supertoys production helpers"
	@echo ""
	@echo "Targets:"
	@echo "  make onboard      - Print first-session onboarding checklist"
	@echo "  make sync-master  - Regenerate derivative docs from story master file"
	@echo "  make watch-master - Watch master file; on save show diff then run sync-master"
	@echo "  make lookdev-init - Create lookdev tracker CSV template"
	@echo "  make script-stills-sync - Regenerate script+stills markdown log"
	@echo "  make submission-init - Create submission metadata templates + tracker"
	@echo "  make submission-check - Validate submission package requirements"
	@echo "  make submission-package - Zip submission folder for handoff"
	@echo "  make plan-8week    - Print 8-week production plan"
	@echo "  make comfy-bootstrap - Clone/install local ComfyUI (venv + requirements)"
	@echo "  make comfy-run-cpu-strong - Start ComfyUI API with strong CPU profile"
	@echo "  make comfy-p17-fast - Submit low-cost P17 preview workflow"
	@echo "  make comfy-p17-hq - Submit high-quality P17 workflow"
	@echo "  make comfy-p17    - Alias for comfy-p17-hq"
	@echo "  make comfy-p07-fast - Submit low-cost P07 preview workflow"
	@echo "  make comfy-p07-hq - Submit high-quality P07 workflow"
	@echo "  make comfy-p07    - Alias for comfy-p07-hq"
	@echo "  make comfy-p25-fast - Submit low-cost P25 preview workflow"
	@echo "  make comfy-p25-hq - Submit high-quality P25 workflow"
	@echo "  make comfy-p25    - Alias for comfy-p25-hq"
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
	@echo "  COMFY_REPO='https://github.com/cartheur-joi/ComfyUI.git' make comfy-bootstrap"

onboard:
	@cat docs/START_HERE.md

sync-master:
	@python3 scripts/sync_from_master.py

watch-master:
	@./scripts/watch_master_sync.sh story/workboard.md

lookdev-init:
	@./scripts/init_lookdev_tracker.sh production/refs/lookdev-tracker.csv

script-stills-sync:
	@python3 scripts/sync_script_stills_log.py

submission-init:
	@./scripts/init_submission_package.sh
	@./scripts/init_submission_tracker.sh reporting/supertoys-festival-submission-tracker.csv

submission-check:
	@./scripts/validate_submission_package.sh

submission-package:
	@mkdir -p "$(EXPORTS_DIR)"
	@zip -r "$(EXPORTS_DIR)/$(PROJECT)_submission_package_$(DATE).zip" production/submission reporting/supertoys-festival-submission-tracker.csv
	@echo "Created $(EXPORTS_DIR)/$(PROJECT)_submission_package_$(DATE).zip"

plan-8week:
	@cat docs/PRODUCTION_PLAN_8WEEKS.md

comfy-bootstrap:
	@./scripts/bootstrap_comfyui.sh

comfy-run-cpu-strong:
	@./scripts/run_comfy_cpu_strong.sh

comfy-p17:
	@$(MAKE) comfy-p17-hq

comfy-p17-fast:
	@./scripts/run_comfy_workflow.sh tools/comfy-workflows/p17-emotional-still-fast.json http://127.0.0.1:8188/prompt

comfy-p17-hq:
	@./scripts/run_comfy_workflow.sh tools/comfy-workflows/p17-emotional-still.json http://127.0.0.1:8188/prompt

comfy-p07:
	@$(MAKE) comfy-p07-hq

comfy-p07-fast:
	@./scripts/run_comfy_workflow.sh tools/comfy-workflows/p07-support-still-fast.json http://127.0.0.1:8188/prompt

comfy-p07-hq:
	@./scripts/run_comfy_workflow.sh tools/comfy-workflows/p07-support-still.json http://127.0.0.1:8188/prompt

comfy-p25:
	@$(MAKE) comfy-p25-hq

comfy-p25-fast:
	@./scripts/run_comfy_workflow.sh tools/comfy-workflows/p25-separation-still-fast.json http://127.0.0.1:8188/prompt

comfy-p25-hq:
	@./scripts/run_comfy_workflow.sh tools/comfy-workflows/p25-separation-still.json http://127.0.0.1:8188/prompt

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
		docs/START_HERE.md \
		docs/PROJECT_INDEX.md \
		docs/PRODUCTION_PLAN_8WEEKS.md \
		reporting/supertoys-animated-screenplay.md \
		reporting/supertoys-festival-submission-tracker.csv \
		planning/supertoys-voice-actor-script.md \
		animatic/supertoys-edit-decision-list.csv; do \
		if [[ -f "$$f" ]]; then echo "  found $$f"; else echo "  missing $$f"; fi; \
	done

package:
	@mkdir -p "$(EXPORTS_DIR)"
	@zip -r "$(EXPORTS_DIR)/$(PROJECT)_docs_animatic_$(DATE).zip" \
		docs/ \
		story/ \
		reporting/ \
		planning/ \
		animatic
	@echo "Created $(EXPORTS_DIR)/$(PROJECT)_docs_animatic_$(DATE).zip"

clean-review:
	@rm -f "$(REVIEW_MP4)" "$(FINAL_MP4)"
	@echo "Removed review/final mp4 outputs."
