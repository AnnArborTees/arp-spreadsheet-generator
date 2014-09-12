module ArpsHelper
  def arp_row_class(arp)
    return 'danger' unless arp.complete?
    return 'success'
  end
end
