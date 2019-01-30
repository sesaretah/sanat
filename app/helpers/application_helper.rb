module ApplicationHelper

  def grant_access(ward, user)
    @flag = 0
    if user.assignments.blank?
      return false
    end
    if user.current_role_id.blank?
      return false
    else
      @ac = AccessControl.where(role_id: user.current_role_id).first
      @flag = @ac["#{ward}"] && 1 || 0
    end

    if @flag == 0
      return false
    else
      return true
    end
  end

  def category_table(category)
    return  "<tr><td>#{category.title}</td><td><div class='tag tag-dark' style='vertical-align: 6px;'>#{category.advertisements.count}<span class='tag-addon tag-success'><i class='far fa-flag' style='vertical-align: -3px;'></i></span></div></td><td><a class='icon' data-confirm='Are you sure?' data-remote='true' href='/categories/#{category.id}/destroy'><i class='fe fe-trash' style='vertical-align:-3px;'></i></a></td></tr>"
  end

   def category_tree(category)
     @children = Category.where(parent_id: category.id)
     if @children.blank?
       return " #{category.title} "
     else
       for child in @children
         return category_tree(child)
       end
     end
   end

end
