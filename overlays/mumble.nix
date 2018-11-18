self: super:
{
   mumble = super.mumble.override (OldAttr: {
     pulseSupport = true;
   });
}
