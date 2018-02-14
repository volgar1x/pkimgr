# Used right now to encrypt PEM files
Rails.application.config.cipher = "AES-256-CTR"

# Do not output <div class="field_with_errors">...</div>
Rails.application.config.action_view.field_error_proc = Proc.new { |html_tag, instance| html_tag }
