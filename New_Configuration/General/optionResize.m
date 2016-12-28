function optionResize(hObject, catval)
global basicdispfig

basicdispfig = hObject;

objH=getappdata(basicdispfig,'subhandles');

if ~isempty(objH)
   for i=1:size(objH,2)
       delete(objH(i));
   end
   PlaceObjects(catval);
end

