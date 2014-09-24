/**
 * Created by jlopez on 9/15/14.
 */
package com.jla.as3.util
{
    import org.hamcrest.assertThat;
    import org.hamcrest.object.equalTo;

    public class StringUtilsTest
    {
        [Test]
        public function shouldPad():void
        {
            assertThat(StringUtils.leftPad("5", 2, '0'), equalTo("05"));
        }

        [Test]
        public function shouldMultiplyZero():void
        {
            assertThat(StringUtils.multiply("0", 0), equalTo(''));
        }

        [Test]
        public function shouldMultiplyOnce():void
        {
            assertThat(StringUtils.multiply("0", 1), equalTo('0'));
        }

        [Test]
        public function shouldMultiplyTwice():void
        {
            assertThat(StringUtils.multiply("0", 2), equalTo('00'));
        }

        [Test]
        public function shouldMultiplyTen():void
        {
            assertThat(StringUtils.multiply("0", 10), equalTo('0000000000'));
        }
    }
}
