# frozen_string_literal: true

require "pagy"
require "pagy/extras/overflow"

# 24 per page divides evenly across the 2/3/4-column catalog grid.
Pagy::DEFAULT[:limit] = 24

# An out-of-range ?page=999 falls back to the last page instead of raising.
Pagy::DEFAULT[:overflow] = :last_page
