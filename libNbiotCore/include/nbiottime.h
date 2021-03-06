/* ========================================================================
 * LibNbiot: nbiottime.h
 *
 * Copyright (c) 2018, Edgar Hindemith, Yassine Amraue, Thorsten
 * Krautscheid, Kolja Vornholt, T-Systems International GmbH
 * contact: libnbiot@t-systems.com, opensource@telekom.de
 *
 * This file is distributed under the conditions of the Apache License,
 * Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * For details see the file LICENSE at the toplevel.
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either expressed or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================================
*/

#ifndef NBIOTTIME_H
#define NBIOTTIME_H

#include "nbiottime_t.h"

/*!
 * \brief The NbiotTime class
 */
class NbiotTime
{
public:
    /*!
     * \brief NbiotTime
     */
    NbiotTime(): data(new NbiotTime_t),ticksPerMs(1),msPerTick(1),ticksCurrentMilli(0), tickLock(false)
    {
        data->timestamp = 0;
        data->millis = 0;
    }
    /*!
     * \brief ~NbiotTime
     */
    virtual ~NbiotTime()
    {
        delete data;
    }

    /*!
     * \brief setTickFrequency
     * \param ticks
     */
    void setTickFrequency(unsigned long ticks);
    /*!
     * \brief getMinDelay
     * \return
     */
    unsigned short getMinDelay() const { return ((0 == msPerTick)? 1 : msPerTick); }
    /*!
     * \brief getMillis
     * \return
     */
    long long getMillis() const;
    /*!
     * \brief addMillis
     * \param ms
     */
    void addMillis(unsigned long ms);
    /*!
     * \brief getTime
     * \return
     */
    time_t getTime();
    /*!
     * \brief setTime
     * \param t
     */
    void setTime(time_t t);

    /*!
     * \brief tick
     */
    void tick();

private:
    NbiotTime(const NbiotTime&);
    NbiotTime& operator=(const NbiotTime&);

    NbiotTime_t* data;

    unsigned short ticksPerMs;
    unsigned short msPerTick;
    unsigned short ticksCurrentMilli;
    bool tickLock;


    static const unsigned short ONE_KHZ = 1000;

};


#endif // NBIOTTIME_H
