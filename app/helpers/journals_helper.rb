module JournalsHelper

	def journal_is_balanced(balanced)
		if balanced == true
			content_tag :span, "Balanced", class: "badge text-bg-success"
		else
			content_tag :span, "Unbalanced", class: "badge text-bg-danger"
		end
	end
end
