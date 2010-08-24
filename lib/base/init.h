
/* Copyright (c) 2008-2010, Stefan Eilemann <eile@equalizergraphics.com> 
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License version 2.1 as published
 * by the Free Software Foundation.
 *  
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more
 * details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this library; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef EQBASE_INIT_H
#define EQBASE_INIT_H

#include <eq/base/base.h>

namespace eq
{
namespace base
{
    /** 
     * Initialize the Equalizer base classes.
     *
     * If the command line parameter '--eq-logfile &lt;filename&gt;' is present,
     * all log output is redirected to the given file.
     *
     * @return <code>true</code> if the library was successfully initialised,
     *         <code>false</code> otherwise.
     * @version 1.0
     */
    EQ_EXPORT bool init( const int argc, char** argv );

    /**
     * De-initialize the Equalizer base classes.
     *
     * @return <code>true</code> if the library was successfully de-initialised,
     *         <code>false</code> otherwise.
     * @version 1.0
     */
    EQ_EXPORT bool exit();
}
}
#endif // EQBASE_INIT_H

