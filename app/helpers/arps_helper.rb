module ArpsHelper
  def arp_row_class(arp)
    return 'danger' if arp.customizable && !arp.custom_artwork_generated?
    return 'danger' if !arp.complete?
    return 'success'
  end
end
