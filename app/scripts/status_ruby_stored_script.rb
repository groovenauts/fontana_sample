module StatusRubyStoredScript

  # argh: Hash
  #    :status_cd
  def apply_status(argh)
    message = ""
    status_cd = argh[:status_cd]
    statuses = game_data["content"]["status"] || []

    # Get status
    status = first(name: "Status", conditions: {"status_cd" => status_cd})

    if status.nil?
      message = "Status is invalid!"
    else
      status_name = status.name

      statuses << status.status_cd
      game_data["content"]["status"] = statuses
      update(name: "GameData", attrs: { "content" => game_data.content })

      message = "You became a #{status_name} state"
    end
    return message
  end

  # argh: Hash
  #    :status_cd
  def recovery_status(argh)
    message = ""
    status_cd = argh[:status_cd]
    statuses = game_data["content"]["status"] || []

    # Get status
    status = first(name: "Status", conditions: {"status_cd" => status_cd})

    if status.nil?
      message = "Status is invalid!"
    else
      status_cd = status.status_cd
      status_name = status.name
      unless statuses.include?(status_cd)
        message = "You don't have #{status_name} state"
      else
        statuses.delete(status.status_cd)
        game_data["content"]["status"] = statuses
        update(name: "GameData", attrs: { "content" => game_data.content })

        message = "Recovery a #{status_name} state"
      end
    end
    return message
  end
end
