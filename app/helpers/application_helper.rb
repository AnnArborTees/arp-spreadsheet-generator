module ApplicationHelper
  def true_false_options_for_select
    options_for_select([['Yes', true], ['No', false]])
  end
end
