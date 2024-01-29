# Add variables to build bitcoin using macports dependencies

export CPPFLAGS="$CPPFLAGS -isystem /opt/local/include"
export LIBS="$LIBS -L/opt/local/lib"

# libevent (mandatory)
#export EVENT_CPPFLAGS="-I/opt/local/include"
#export EVENT_LIBS="-I/opt/local/lib"

# Berkeley-db (optional)
#export BDB_CFLAGS="/opt/local/lib/db48"
#export CPPFLAGS="$CPPFLAGS -I/opt/local/include/db48"

# Miniupnpc (optional)
#export MINIUPNPC_CPPFLAGS="-I/opt/local/include"
#export MINIUPNPC_LIBS="-L/opt/local/lib"

# libmultiprocess (optional)
#export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"
#export LIBMULTIPROCESS_CFLAGS="-I/usr/local/include"
#export LIBMULTIPROCESS_LIBS="-L/usr/local/lib"
