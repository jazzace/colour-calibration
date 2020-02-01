(* 
Template Copyright ( C ) 2011 Apple Inc. All Rights Reserved.
*)

(* INSTRUCTIONS
This droplet is designed to process one or more files, whose icons are dragged onto the droplet icon. The droplet also provides access to user-settable properties through a dialog displayed when the applet is run as an application.
This script copies ColorSync profiles to a location needed by customdisplayprofiles. For a different location than the one chosen here, change the value of target_parent_dir in the process_files subroutine.
*)

property extension_list : {"icc"}

property post_alert : "Yes"

on run
	repeat
		display dialog "This droplet will process ICC files dragged onto its icon." & linefeed & linefeed & "There is a user-settable preference for displaying an alert dialog when the droplet encounters a dragged-on item that is not a file of the type processed by the droplet." & return & return & "Post User Alert: " & (post_alert as text) buttons {"Set Prefs", "Done"} default button 2 with title "My File Processing Droplet"
		if the button returned of the result is "Set Prefs" then
			display dialog "Should this droplet post an alert dialog when items that are not files are dragged onto it?" & return & return & "Current Status: " & (post_alert as text) buttons {"No", "Yes"} default button post_alert
			if the button returned of the result is "Yes" then
				set post_alert to "Yes"
			else
				set post_alert to "No"
			end if
		else
			return "done"
		end if
	end repeat
end run

-- This droplet processes files dropped onto the applet 
on open these_items
	repeat with i from 1 to the count of these_items
		set this_item to item i of these_items
		set the item_info to info for this_item
		set this_name to the name of the item_info
		try
			set this_extension to the name extension of item_info
		on error
			set this_extension to ""
		end try
		if (folder of the item_info is false) and (alias of the item_info is false) and (this_extension is in the extension_list) then
			-- THE ITEM IS AN ICC FILE AND CAN BE PROCESSED
			process_item(this_item, this_name)
		else if post_alert is "Yes" then
			display alert "PROCESSING ALERT" message "The item Ò" & this_name & "Ó is not a file that this droplet can process." buttons {"Cancel", "Continue"} default button 2 cancel button "Cancel" as warning
		end if
	end repeat
end open

-- this sub-routine processes files 
on process_item(profile_path, profile_name)
	set target_parent_dir to "/Library/ColorSync/Profiles/Custom/"
	set posix_profile_path to the POSIX path of profile_path
	display dialog "The profile Ò" & profile_name & "Ó should be assigned to which display number? (1 = primary or only, 2 = secondary, Skip = neither)" buttons {"1", "2", "Skip"} default button "1"
	set display_num to button returned of the result
	if display_num ­ "Skip" then
		set target_dir to target_parent_dir & display_num
		-- Remove existing target directory to clear out old profiles if present, then (re-)create and place dropped profile in folder
		do shell script "if [ -d " & quoted form of target_dir & " ] ; then rm -R " & quoted form of target_dir & " ; fi ; mkdir -p " & quoted form of target_dir & " ; cp " & quoted form of posix_profile_path & " " & quoted form of target_dir user name "admin" password "password" with administrator privileges
		
	end if
end process_item
