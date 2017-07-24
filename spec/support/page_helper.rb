module PageHelper
  def find_node_by_text text
    page.find(:xpath,"//*[text()='#{text}']")
  end
end
