
/* Copyright (c) 2013, Stefan.Eilemann@epfl.ch
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

#include <co/co.h>
#include <test.h>

enum Commands
{
    CMD_ASYNC = co::CMD_NODE_CUSTOM,
    CMD_SYNC
};

class LocalNode : public co::LocalNode
{
    typedef co::CommandFunc< LocalNode > CmdFunc;

public:
    LocalNode()
        : gotAsync_( false )
    {
        co::CommandQueue* q = getCommandThreadQueue();
        registerCommand( CMD_ASYNC, CmdFunc( this, &LocalNode::_cmdAsync ), q );
        registerCommand( CMD_SYNC, CmdFunc( this, &LocalNode::_cmdSync ), q );
    }

private:
    bool gotAsync_;

    bool _cmdAsync( co::ICommand& )
    {
        gotAsync_ = true;
        return true;
    }

    bool _cmdSync( co::ICommand& command )
    {
        TEST( gotAsync_ );
        ackRequest( command.getNode(), command.get< uint32_t >( ));
        return true;
    }
};

typedef lunchbox::RefPtr< LocalNode > LocalNodePtr;

int main( int argc, char **argv )
{
    TEST( co::init( argc, argv ) );

    co::ConnectionDescriptionPtr connDesc = new co::ConnectionDescription;

    lunchbox::RNG rng;
    connDesc->type = co::CONNECTIONTYPE_TCPIP;
    connDesc->port = (rng.get<uint16_t>() % 60000) + 1024;
    connDesc->setHostname( "localhost" );

    LocalNodePtr server = new LocalNode;
    server->addConnectionDescription( connDesc );
    TEST( server->listen( ));

    co::NodePtr serverProxy = new co::Node;
    serverProxy->addConnectionDescription( connDesc );

    connDesc = new co::ConnectionDescription;
    connDesc->type = co::CONNECTIONTYPE_TCPIP;
    connDesc->setHostname( "localhost" );

    LocalNodePtr client = new LocalNode;
    client->addConnectionDescription( connDesc );
    TEST( client->listen( ));
    TEST( client->connect( serverProxy ));

    const uint32_t request = client->registerRequest();

    serverProxy->send( CMD_ASYNC );
    lunchbox::sleep( 5 /*ms*/ ); // get first one processed for sure

    lunchbox::Clock clock;
    serverProxy->send( CMD_SYNC ) << request;
    const float asyncTime = clock.resetTimef();

    client->waitRequest( request );
    const float syncTime = clock.resetTimef();

    std::cout << "Async command: " << asyncTime << " ms, sync: " << syncTime
              << " ms" << std::endl;

    TEST( client->disconnect( serverProxy ));
    TEST( client->close( ));
    TEST( server->close( ));

    serverProxy->printHolders( std::cerr );
    TESTINFO( serverProxy->getRefCount() == 1, serverProxy->getRefCount( ));
    TESTINFO( client->getRefCount() == 1, client->getRefCount( ));
    TESTINFO( server->getRefCount() == 1, server->getRefCount( ));

    serverProxy = 0;
    client      = 0;
    server      = 0;

    TEST( co::exit( ));

    return EXIT_SUCCESS;
}
