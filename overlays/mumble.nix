self: super:
{
   mumble = super.mumble.override {
     pulseSupport = true;
   };
};
