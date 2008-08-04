require "invoice"

sender = <<-EOS
Gregory Brown
200 Wonderful Drive
New Haven, CT 06511
EOS

recipient = <<-EOS
Cool Inc.
100 Awesome Street
West Foo, VT 01102
EOS

invoice = Invoice.new(:sender    => sender,
                      :recipient => recipient,
                      :period    => "2008.08.01 - 2008.08.31",
                      :due       => "September 30th, 2008") 

invoice.entry "Work on something awesome",  :hours => 10.5, :rate => 75.0
invoice.entry "Work on something terrible", :hours => 5.0,  :rate => 125.0
invoice.entry "Work on free software",      :hours => 20.0, :rate => 25.0
invoice.entry "Work for non-profit org",    :hours => 30.0, :rate => 45.0 

invoice.save_as "output/invoice.pdf"